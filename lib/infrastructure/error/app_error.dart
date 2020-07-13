
/// Program hatası vb istisna durumlarında kullanılacak, null referance vb...
/// Hatayı tanımlayan bir mesaj içerir. Kullanıcıya gösterilecek bir mesaj içermez.
/// Kullanılcıyı bilgilendirmenin gerektiği hata durumlarında [AppException] sınıfı kullanılabilir.
class AppError implements Error {
  AppError(this.message, [this._stackTrace]);

  String message;
  StackTrace _stackTrace;

  @override
  String toString() {
    return message ?? 'AppError';
  }
  @override
  StackTrace get stackTrace => _stackTrace;
  
}
