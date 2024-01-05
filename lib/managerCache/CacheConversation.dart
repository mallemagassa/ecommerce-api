import 'package:ecommerce/managerCache/IOFileSystem.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheConversation  extends CacheManager {
  
  static const key = 'cacheConversation';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(seconds:1),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );

  CacheConversation(super.config);

}