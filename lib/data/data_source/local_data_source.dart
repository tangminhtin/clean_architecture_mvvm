import 'package:clean_architecture_mvvm/data/network/error_handler.dart';
import 'package:clean_architecture_mvvm/data/responses/responses.dart';

const cacheHomeKey = 'CACHE_HOME_KEY';
const cacheHomeInterval = 60 * 1000; // 1 minute in millis
const cacheStoreDetailsKey = 'CACHE_STORE_DETAILS_KEY';
const cacheStoreDetailsInterval = 60 * 1000; // 1 minute in millis

abstract class LocalDataSource {
  Future<HomeResponse> getHome();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  void clearCache();
  void removeFromCache(String key);
  Future<StoreDetailsResponse> getStoreDetails();
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response);
}

class LocalDataSourceImplementer implements LocalDataSource {
  // Run time cache
  Map<String, CachedItem> cacheMap = {};

  @override
  Future<HomeResponse> getHome() async {
    CachedItem? cachedItem = cacheMap[cacheHomeKey];

    if (cachedItem != null && cachedItem.isValid(cacheHomeInterval)) {
      // Return the response from cache
      return cachedItem.data;
    } else {
      // Return error that from cache is not valid
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[cacheHomeKey] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async {
    CachedItem? cachedItem = cacheMap[cacheStoreDetailsKey];
    if (cachedItem != null && cachedItem.isValid(cacheStoreDetailsInterval)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response) async {
    cacheMap[cacheStoreDetailsKey] = CachedItem(response);
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTime) {
    // Expiration time is 60 secs
    int currentTimeInMills =
        DateTime.now().millisecondsSinceEpoch; // Time now is 1:00:00 pm
    bool isCachedValid = currentTimeInMills - expirationTime <
        cacheTime; // Cache time was in 12:59:30
    // False if current time > 1:00:30
    // True if current time < 1:00:30
    return isCachedValid;
  }
}
