{ ... }:

{
  services.syncthing = {
    enable = true;

    settings = {
      devices = {
        pc.id = "SK3HCCN-ZXSDV3G-IPSDPSR-UP6PBVC-RZT4FMP-YNJZJEF-UDEZZJ4-A3ARHQ6";
        xmg.id = "V2MBCYZ-6HXPK3L-CELM2CO-CWLN4BQ-OZEPPF3-OUZYYHW-IC4SSBS-BXGOYQZ";
        dell.id = "3TPWPUA-QZHBKGH-VBB3KPR-AJOPAWO-LGXVKVX-P3YSWKI-XKNREPK-7VTCRQJ";
        pixel.id = "MIK4BFI-EI532KJ-ZYX46WI-AUUIRUX-KVW62SO-WTKU32S-D6XNL2Y-BHX7OAE";
      };

      folders = {
        Music = {
          path = "/home/simon/Music";
          devices = [
            "pc"
            "xmg"
            "dell"
          ];
        };
        Documents = {
          path = "/home/simon/Documents";
          devices = [
            "pc"
            "dell"
            "pixel"
            "xmg"
          ];
        };
        Downloads = {
          path = "/home/simon/Downloads";
          devices = [
            "pc"
            "dell"
          ];
        };
        Notes = {
          path = "/home/simon/obsidian-vault";
          devices = [
            "dell"
            "pixel"
          ];
        };
      };
    };
  };
}
