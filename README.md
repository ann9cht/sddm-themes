# sddm-themes

Các theme SDDM cá nhân, đóng gói thành NixOS module để dùng trong config NixOS của mình.

## Xem trước

Xem tại [cấu hình nixos](https://github.com/ann9cht/nixos-config) của mình.

## Nguồn gốc

Mình biết tới theme này qua shell [Serpantinum](https://github.com/ilyamiro/serpantinum). Trước đó, README của Serpantinum ghi rõ theme được lấy từ [qylock](https://github.com/Darkkal44/qylock) của Darkkal44.

Bản gốc có tông màu xanh lục không hợp với nền của mình, nên mình đã fork về để Việt hoá và chỉnh lại tông màu cho phù hợp.

## Vì sao có repo này

Trước đây, theme nằm trong repo Serpantinum, mình dùng patch để áp bản chỉnh sửa của mình lên đó. Gần đây, Serpantinum đổi hoàn toàn sang một theme mới (vẫn giữ tên cũ), patch cũ không còn dùng được.

Vì vậy mình tách ra repo riêng, kèm flake để kéo thẳng vào config NixOS, và đưa luôn theme mới mà Serpantinum đang dùng vào đây để tiện chỉnh sửa tiếp, đổi theme theo ý thích.

Repo này dùng hoàn toàn cho mục đích cá nhân, không có cam kết bảo trì hay hỗ trợ. Ai thấy dùng được thì cứ tự nhiên.

## Các theme

- `material-you`: bản Việt hoá và chỉnh tông màu từ qylock.
- `material-you-v2`: theme mới mà Serpantinum đang dùng.

## Sử dụng

Thêm input vào `flake.nix`:

```nix
inputs.sddm-themes.url = "github:ann9cht/sddm-themes";
```

Rồi trong cấu hình NixOS:

```nix
{ pkgs, inputs, ... }:
{
  imports = [ inputs.sddm-themes.nixosModules.default ];

  programs.sddm-themes = {
    enable = true;
    theme = "material-you"; # hoặc "material-you-v2"

    # Tuỳ, bỏ đi thì SDDM dùng cursor mặc định
    cursor = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };
}
```

Module tự bật `services.xserver` và `services.displayManager.sddm`, đặt theme, và cài package cursor vào system. `cursor.name` là tên thư mục dưới `share/icons/` của package.

## Cảm ơn

- [ilyamiro/serpantinum](https://github.com/ilyamiro/serpantinum): nơi mình biết tới theme này.
- [Darkkal44/qylock](https://github.com/Darkkal44/qylock): tác giả của theme gốc.

## Giấy phép

Theme gốc của Darkkal44 theo giấy phép GPL-3.0. Bản quyền phần gốc thuộc về tác giả.
