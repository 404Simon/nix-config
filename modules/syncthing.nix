{ ... }:

{
  services.syncthing = {
    enable = true;

    settings = {
      devices = {
        xmg.id = "V2MBCYZ-6HXPK3L-CELM2CO-CWLN4BQ-OZEPPF3-OUZYYHW-IC4SSBS-BXGOYQZ";
        dell.id = "3TPWPUA-QZHBKGH-VBB3KPR-AJOPAWO-LGXVKVX-P3YSWKI-XKNREPK-7VTCRQJ";
      };

      folders = {
        Music = {
          path = "/home/simon/Music";
          type = "sendonly";
          devices = [
            "xmg"
            "dell"
          ];
        };
      };
    };
  };
}
