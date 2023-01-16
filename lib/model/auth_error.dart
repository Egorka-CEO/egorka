String authError(String str) {
  switch (str) {
    case 'Wrong request':
      return 'Неверный запрос';
    case 'User not found':
      return 'Пользователь не найден';
    case 'Password is wrong':
      return 'Пароль неверный';
    case 'Company not found':
      return 'Компания не найдена';
    default:
      return 'Ошибка: $str';
  }
}
