From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 01 Feb 2017 16:26:49 +0100
Message-ID: <2760877.KV1ZkH9Fsg@wuerfel>
In-Reply-To: <5891FA4B.32537.F0660DA@pageexec.freemail.hu>
References: <1993222.Sl7urNjWky@wuerfel> <5891FA4B.32537.F0660DA@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3227335.XSoIECOhKP"
Content-Transfer-Encoding: 7Bit
Subject: [kernel-hardening] Re: initify plugin crashes on arm allmodconfig
To: pageexec@freemail.hu
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.

--nextPart3227335.XSoIECOhKP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, February 1, 2017 4:10:03 PM CET PaX Team wrote:
> On 1 Feb 2017 at 14:52, Arnd Bergmann wrote:
> 
> > On my ARM test builds (using a recent gcc-7 snapshot), allmodconfig failed with a compiler
> > crash, I have managed to minimize the test case to this:
> > 
> > /home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-7.0.1 -O2 -Wall -fplugin=/home/arnd/arm-soc/build/tmp/scripts/gcc-plugins/initify_plugin.so -DINITIFY_PLUGIN
> > -fplugin-arg-initify_plugin-search_init_exit_functions  -fno-inline-functions-called-once -S atmel_lcdfb.i arm-linux-gnueabi-gcc-7.0.1: internal compiler error: Segmentation fault (program cc1)
> > 
> [...]
> > 
> > While trying to reproduce it, one time I ended up killing the gcc task when it
> > used more than 80 gigabytes (!) of memory after around six minutes of compiling
> > the same file (drivers/video/fbdev/atmel_lcdfb.c), but other times it just crashed
> > as above using various ARM cross compilers (4.9.3, 5.3, 6.1.1).
> 
> i tried to reproduce it with 5.4 and 6.3 to no avail (arm64->arm cross compiler)
> so some more information will be needed. first, which plugin version did you try?
> second, if you build your own gcc, can you configure one with this additional
> option:

The plugin version is from today's next-20170201 version, and that is the
only version I've seen so far. Unfortunately I could not reproduce on
plain linux-next but only on my working tree, which contains countless
other patches.

I took some snapshots during the creduce run, the attached file is not fully
reduced but for me this version crashes on gcc-4.9.3, 5.3.1, 6.1.1, and 7.0.1.

I think the 4.9.3 build still had checks enabled, this is the output I get there:

arm-linux-gnueabi-gcc-4.9.3: internal compiler error: Segmentation fault (program cc1)
0x40c0c6 execute
	/home/arnd/git/gcc/gcc/gcc.c:2854
0x40c464 do_spec_1
	/home/arnd/git/gcc/gcc/gcc.c:4658
0x40edc0 process_brace_body
	/home/arnd/git/gcc/gcc/gcc.c:5941
0x40edc0 handle_braces
	/home/arnd/git/gcc/gcc/gcc.c:5855
0x40d16e do_spec_1
	/home/arnd/git/gcc/gcc/gcc.c:5312
0x40edc0 process_brace_body
	/home/arnd/git/gcc/gcc/gcc.c:5941
0x40edc0 handle_braces
	/home/arnd/git/gcc/gcc/gcc.c:5855
0x40d16e do_spec_1
	/home/arnd/git/gcc/gcc/gcc.c:5312
0x40d0d3 do_spec_1
	/home/arnd/git/gcc/gcc/gcc.c:5427
0x40edc0 process_brace_body
	/home/arnd/git/gcc/gcc/gcc.c:5941
0x40edc0 handle_braces
	/home/arnd/git/gcc/gcc/gcc.c:5855
0x40d16e do_spec_1
	/home/arnd/git/gcc/gcc/gcc.c:5312
0x40edc0 process_brace_body
	/home/arnd/git/gcc/gcc/gcc.c:5941
0x40edc0 handle_braces
	/home/arnd/git/gcc/gcc/gcc.c:5855
0x40d16e do_spec_1
	/home/arnd/git/gcc/gcc/gcc.c:5312
0x40edc0 process_brace_body
	/home/arnd/git/gcc/gcc/gcc.c:5941
0x40edc0 handle_braces
	/home/arnd/git/gcc/gcc/gcc.c:5855
0x40d16e do_spec_1
	/home/arnd/git/gcc/gcc/gcc.c:5312
0x40edc0 process_brace_body
	/home/arnd/git/gcc/gcc/gcc.c:5941
0x40edc0 handle_braces
	/home/arnd/git/gcc/gcc/gcc.c:5855
Please submit a full bug report,
with preprocessed source if appropriate.
Please include the complete backtrace with any bug report.
See <http://gcc.gnu.org/bugs.html> for instructions.

If you can't reproduce with the version below, I'll dig in further.

	Arnd
--nextPart3227335.XSoIECOhKP
Content-Disposition: attachment; filename="atmel_lcdfb.i.4"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="atmel_lcdfb.i.4"

enum { false };
extern int __this_module;
struct list_head {
  struct list_head *next, *prev;
};
struct resource;
extern struct resource *__request_region(void);
extern void lockdep_init_map(int *key);
typedef void *work_func_t;
struct work_struct {
  work_func_t func;
};
typedef int pm_message_t;
struct device {
  void *driver_data;
  int *of_node;
};
static inline __attribute__((no_instrument_function)) void *
dev_get_drvdata(const struct device *dev) {
  return dev->driver_data;
}
extern __attribute__((format(printf, 2, 3))) void
dev_err(const struct device *dev, const char *fmt, ...);
struct platform_device_id {
  char name[20];
  unsigned long driver_data;
};
struct platform_device {
  struct device dev;
  const struct platform_device_id *id_entry;
};
struct platform_driver {
  int (*remove)(struct platform_device *);
  int (*suspend)(struct platform_device *, pm_message_t state);
  int (*resume)(struct platform_device *);
  const struct platform_device_id *id_table;
};
extern int __platform_driver_probe(struct platform_driver *driver,
                                   int(struct platform_device *), int *module);
static inline __attribute__((no_instrument_function)) void
__raw_writel(unsigned int val, volatile void *addr) {}
unsigned int __raw_readl_val;
static inline __attribute__((no_instrument_function)) unsigned int
__raw_readl(const volatile void *addr) {
  return __raw_readl_val;
}
enum irqreturn { IRQ_HANDLED };
typedef enum irqreturn (*irq_handler_t)(int, void *);
static inline __attribute__((no_instrument_function)) int
    __attribute__((warn_unused_result)) request_irq(irq_handler_t handler) {
  return 0;
}
extern int *of_parse_phandle(const int *np);
int *of_property_read_u32_child;
int of_property_read_u32_num = 0;
static inline __attribute__((no_instrument_function)) int
of_property_read_u32(unsigned int *out_value) {
  for (of_property_read_u32_child = 0; 0 != 0; of_property_read_u32_child = 0)
    of_property_read_u32_num++;
  return 0;
}
struct fb_fix_screeninfo {};
struct fb_bitfield {
  unsigned int offset;
};
struct fb_var_screeninfo {
  unsigned int bits_per_pixel;
  struct fb_bitfield red;
  struct fb_bitfield green;
  struct fb_bitfield blue;
  unsigned int pixclock;
  unsigned int vsync_len;
};
enum { FB_BLANK_UNBLANK, FB_BLANK_NORMAL, FB_BLANK_POWERDOWN };
struct backlight_properties;
struct fb_info;
struct backlight_ops {
  int (*update_status)(struct backlight_properties *);
  int (*get_brightness)(struct backlight_properties *);
};
extern struct backlight_properties *
backlight_device_register(const struct backlight_ops *ops);
struct fb_ops {
  int *owner;
  int (*fb_check_var)(struct fb_var_screeninfo *var, struct fb_info *info);
  int (*fb_set_par)(struct fb_info *info);
  int (*fb_setcolreg)(unsigned regno, unsigned red, unsigned green,
                      unsigned blue, unsigned transp, struct fb_info *info);
  int (*fb_blank)(int blank, struct fb_info *info);
  int (*fb_pan_display)(struct fb_var_screeninfo *var, struct fb_info *info);
};
struct fb_info {
  struct fb_var_screeninfo var;
  struct fb_fix_screeninfo fix;
  struct list_head modelist;
  struct device *device;
  void *par;
};
extern struct fb_info *framebuffer_alloc(struct device *dev);
struct fb_modelist {
  struct list_head list;
} arm_delay_ops;
int __attribute__((warn_unused_result)) regulator_enable(void);
struct atmel_lcdfb_pdata {
  _Bool lcdcon_is_backlight;
  _Bool lcdcon_pol_negative;
  unsigned char lcd_wiring_mode;
  unsigned int default_lcdcon2;
  unsigned int default_dmacon;
  void (*atmel_lcdfb_power_control)(struct atmel_lcdfb_pdata *pdata, int on);
  struct list_head pwr_gpios;
};
struct atmel_lcdfb_config {
  _Bool have_hozval;
  _Bool have_intensity_bit;
};
struct atmel_lcdfb_info {
  struct fb_info *info;
  void *mmio;
  struct work_struct task;
  struct platform_device *pdev;
  struct atmel_lcdfb_pdata pdata;
  struct atmel_lcdfb_config *config;
  int *reg_lcd;
};
struct atmel_lcdfb_power_ctrl_gpio {
  struct list_head list;
};
static struct atmel_lcdfb_config at91sam9261_config;
static struct atmel_lcdfb_config at91sam9263_config;
static struct atmel_lcdfb_config at91sam9g10_config;
static struct atmel_lcdfb_config at91sam9g45_config;
static struct atmel_lcdfb_config at91sam9g45es_config;
static struct atmel_lcdfb_config at91sam9rl_config;
static struct atmel_lcdfb_config at32ap_config;
static const struct platform_device_id atmel_lcdfb_devtypes[] = {
    {.name = "at91sam9261lcdfb",
     .driver_data = (unsigned long)&at91sam9261_config},
    {.name = "at91sam9263lcdfb",
     .driver_data = (unsigned long)&at91sam9263_config},
    {.name = "at91sam9g10lcdfb",
     .driver_data = (unsigned long)&at91sam9g10_config},
    {.name = "at91sam9g45lcdfb",
     .driver_data = (unsigned long)&at91sam9g45_config},
    {.name = "at91sam9g45eslcdfb",
     .driver_data = (unsigned long)&at91sam9g45es_config},
    {.name = "at91sam9rllcdfb",
     .driver_data = (unsigned long)&at91sam9rl_config},
    {.name = "at32aplcdfb", .driver_data = (unsigned long)&at32ap_config}};
struct platform_device *atmel_lcdfb_get_config_pdev;
static unsigned int contrast_ctr = 3 << 0 | 1 << 2 | 1 << 3;
static int atmel_bl_update_status(struct backlight_properties *b) { return 0; }
static int atmel_bl_get_brightness(struct backlight_properties *b) { return 0; }
static const struct backlight_ops atmel_lcdc_bl_ops = {
    .update_status = atmel_bl_update_status,
    .get_brightness = atmel_bl_get_brightness};
struct backlight_properties *init_backlight_bl;
struct atmel_lcdfb_info *init_contrast_sinfo;
int atmel_lcdfb_power_control_ret;
static inline __attribute__((no_instrument_function)) void
atmel_lcdfb_power_control(struct atmel_lcdfb_info *sinfo, int on) {
  struct atmel_lcdfb_pdata *pdata = &sinfo->pdata;
  if (pdata->atmel_lcdfb_power_control)
    pdata->atmel_lcdfb_power_control(pdata, on);
  else if (on) {
    atmel_lcdfb_power_control_ret = regulator_enable();
    dev_err(&sinfo->pdev->dev, "lcd regulator enable failed	%d\n",
            atmel_lcdfb_power_control_ret);
  }
}
static struct fb_fix_screeninfo atmel_lcdfb_fix
    __attribute__((__section__(".init.data")));
struct atmel_lcdfb_info compute_hozval_sinfo;
unsigned long compute_hozval_xres;
static void atmel_lcdfb_start(struct atmel_lcdfb_info *sinfo) {
  struct atmel_lcdfb_pdata *pdata = &sinfo->pdata;
  __raw_writel(pdata->default_dmacon, sinfo->mmio + 0x1c);
}
unsigned int atmel_lcdfb_check_var___UNIQUE_ID_min2_15 = 1;
static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
                                 struct fb_info *info) {
  const int *__trans_tmp_1;
  struct device dev = *(info->device);
  struct atmel_lcdfb_info *sinfo = info->par;
  struct atmel_lcdfb_pdata pdata = sinfo->pdata;
  {
    { __trans_tmp_1 = 0; }
    dev_err(&dev, "needed value not specified\n");
  }
  do
    ;
  while (0);
  var->vsync_len = ({
    unsigned int __UNIQUE_ID_min1_14 = var->vsync_len;
    __UNIQUE_ID_min1_14 < atmel_lcdfb_check_var___UNIQUE_ID_min2_15;
  });
  switch (var->bits_per_pixel) {
  case 1:
  case 2:
  case 4:
  case 8:
    var= 0;
    if (pdata.lcd_wiring_mode == 1)
      ;
  }
  return 0;
}
static void atmel_lcdfb_reset(struct atmel_lcdfb_info *sinfo) {}
unsigned long atmel_lcdfb_set_par_value;
static int atmel_lcdfb_set_par(struct fb_info *info) {
  unsigned long __trans_tmp_2;
  struct atmel_lcdfb_info *sinfo = info->par;
  struct atmel_lcdfb_pdata pdata = sinfo->pdata;
  atmel_lcdfb_set_par_value = pdata.default_lcdcon2;
  { __trans_tmp_2 = compute_hozval_xres; }
  return 0;
}
static int atmel_lcdfb_setcolreg(unsigned int regno, unsigned int red,
                                 unsigned int green, unsigned int blue,
                                 unsigned int transp, struct fb_info *info) {
  struct atmel_lcdfb_info *sinfo = info->par;
  struct atmel_lcdfb_pdata pdata = sinfo->pdata;
  {
    if (pdata.lcd_wiring_mode == 1)
      ;
  }
  return 1;
}
static int atmel_lcdfb_pan_display(struct fb_var_screeninfo *var,
                                   struct fb_info *info) {
  do
    ;
  while (0);
  return 0;
}
static int atmel_lcdfb_blank(int blank_mode, struct fb_info *info) {
  struct atmel_lcdfb_info *sinfo = info->par;
  switch (blank_mode) {
  case FB_BLANK_UNBLANK:
  case FB_BLANK_NORMAL:
    atmel_lcdfb_start(sinfo);
  }
  return blank_mode == FB_BLANK_NORMAL ? 1 : 0;
}
static struct fb_ops atmel_lcdfb_ops = {.owner = &__this_module,
                                        .fb_check_var = atmel_lcdfb_check_var,
                                        .fb_set_par = atmel_lcdfb_set_par,
                                        .fb_setcolreg = atmel_lcdfb_setcolreg,
                                        .fb_blank = atmel_lcdfb_blank,
                                        .fb_pan_display =
                                            atmel_lcdfb_pan_display};
unsigned int atmel_lcdfb_interrupt_status;
static enum irqreturn atmel_lcdfb_interrupt(int irq, void *dev_id) {
  struct fb_info *info = dev_id;
  struct atmel_lcdfb_info *sinfo = info->par;
  atmel_lcdfb_interrupt_status = __raw_readl(sinfo->mmio + 0x0854);
  return IRQ_HANDLED;
}
static void atmel_lcdfb_task(void) {
  struct atmel_lcdfb_info sinfo;
  atmel_lcdfb_reset(&sinfo);
}
struct atmel_lcdfb_info atmel_lcdfb_init_fbinfo_sinfo;
static void atmel_lcdfb_start_clock(struct atmel_lcdfb_info *sinfo) {}
static void atmel_lcdfb_stop_clock(void) {}
static const char *atmel_lcdfb_wiring_modes[] = {[0] = "BRGRGB"};
int atmel_lcdfb_get_of_wiring_modes_i;
struct atmel_lcdfb_power_ctrl_gpio *atmel_lcdfb_power_control_gpio_og;
struct list_head atmel_lcdfb_power_control_gpio_og_1_0;
static void atmel_lcdfb_power_control_gpio(struct atmel_lcdfb_pdata *pdata,
                                           int on) {
  for (atmel_lcdfb_power_control_gpio_og = ({
         const typeof(((typeof(*atmel_lcdfb_power_control_gpio_og) *)0)->list)
             __mptr = *((&pdata->pwr_gpios)->next);
         (typeof(*atmel_lcdfb_power_control_gpio_og) *)&__mptr -
             __builtin_offsetof(typeof(*atmel_lcdfb_power_control_gpio_og),
                                list);
       });
       &atmel_lcdfb_power_control_gpio_og->list != &pdata->pwr_gpios;
       atmel_lcdfb_power_control_gpio_og = ({
         const typeof(((typeof(*atmel_lcdfb_power_control_gpio_og) *)0)->list)
             __mptr = atmel_lcdfb_power_control_gpio_og_1_0;
         (typeof(*atmel_lcdfb_power_control_gpio_og) *)&__mptr -
             __builtin_offsetof(typeof(*atmel_lcdfb_power_control_gpio_og),
                                list);
       }))
    ;
}
int *atmel_lcdfb_of_init_display_np;
int atmel_lcdfb_of_init_ret = 2;
int atmel_lcdfb_of_init_i;
int atmel_lcdfb_of_init_gpio;
struct atmel_lcdfb_info *atmel_lcdfb_of_init_sinfo;
static int atmel_lcdfb_of_init(void) {
  int __trans_tmp_3;
  struct fb_info *info = atmel_lcdfb_of_init_sinfo->info;
  struct atmel_lcdfb_pdata *pdata = &atmel_lcdfb_of_init_sinfo->pdata;
  struct fb_var_screeninfo var = info->var;
  struct device dev = atmel_lcdfb_of_init_sinfo->pdev->dev;
  int *np = dev.of_node;
  atmel_lcdfb_of_init_display_np = of_parse_phandle(np);
  atmel_lcdfb_of_init_ret = of_property_read_u32(&var.bits_per_pixel);
  for (atmel_lcdfb_of_init_i = 0; 0 < 0; atmel_lcdfb_of_init_i++)
    atmel_lcdfb_of_init_gpio = 0;
  goto put_display_node;
  pdata->atmel_lcdfb_power_control = atmel_lcdfb_power_control_gpio;
  {
    for (atmel_lcdfb_get_of_wiring_modes_i = 0;
         0 < sizeof(atmel_lcdfb_wiring_modes) / sizeof sizeof(struct {});
         atmel_lcdfb_get_of_wiring_modes_i++)
      __trans_tmp_3 = 0;
  }
put_display_node:
  return atmel_lcdfb_of_init_ret;
}
struct fb_info *atmel_lcdfb_probe_info;
char *atmel_lcdfb_probe_info_5_0;
struct fb_ops atmel_lcdfb_probe_info_3;
struct atmel_lcdfb_info *atmel_lcdfb_probe_sinfo;
void *atmel_lcdfb_probe_sinfo_1;
struct fb_modelist *atmel_lcdfb_probe_modelist;
int atmel_lcdfb_probe_ret;
static int __attribute__((__section__(".init.text"))) __attribute__((__cold__))
__attribute__((no_instrument_function))
atmel_lcdfb_probe(struct platform_device *pdev) {
  int __trans_tmp_6;
  int __trans_tmp_5;
  struct atmel_lcdfb_config *__trans_tmp_4;
  if (atmel_lcdfb_probe_info)
    goto out;
  atmel_lcdfb_probe_ret = atmel_lcdfb_of_init();
  if (atmel_lcdfb_probe_ret)
    goto free_info;
  else {
    {
      __trans_tmp_4 = (struct atmel_lcdfb_config *)
                          atmel_lcdfb_get_config_pdev->id_entry->driver_data;
    }
  }
  atmel_lcdfb_probe_info_3 = atmel_lcdfb_ops;
  atmel_lcdfb_probe_info->fix = atmel_lcdfb_fix;
  if (0)
    goto put_bus_clk;
  atmel_lcdfb_probe_modelist = ({
    const typeof(((struct fb_modelist *)0)->list) __mptr =
        *((&atmel_lcdfb_probe_info->modelist)->next);
    (struct fb_modelist *)&__mptr -
        __builtin_offsetof(struct fb_modelist, list);
  });
  if (0) {
    goto release_intmem;
  } else {
    { __trans_tmp_5 = 0; }
  }
  if (0 < 0)
    goto stop_clk;
  if (__request_region())
    goto free_fb;
  if (atmel_lcdfb_probe_sinfo_1)
    goto release_mem;
  {
    struct atmel_lcdfb_pdata pdata = init_contrast_sinfo->pdata;
    contrast_ctr = 1 << 2;
    if (pdata.lcdcon_is_backlight) {
      { init_backlight_bl = backlight_device_register(&atmel_lcdc_bl_ops); }
    }
  }
  atmel_lcdfb_probe_ret = request_irq(atmel_lcdfb_interrupt);
  if (atmel_lcdfb_probe_ret)
    goto unmap_mmio;
  do {
    static int __key;
    lockdep_init_map(&__key);
    (&atmel_lcdfb_probe_sinfo->task)->func = atmel_lcdfb_task;
  } while (0);
  {
    struct fb_info info = *(atmel_lcdfb_init_fbinfo_sinfo.info);
    dev_err(info.device, "Alloc color map failed\n");
    __trans_tmp_6 = 0;
  }
  if (0 < 0)
    goto unregister_irqs;
  if (0 < 0)
    goto reset_drvdata;
  atmel_lcdfb_power_control(atmel_lcdfb_probe_info->par, 1);
reset_drvdata:
unregister_irqs:
unmap_mmio:
release_mem:
free_fb:
release_intmem:
stop_clk:
  atmel_lcdfb_stop_clock();
put_bus_clk:
free_info:
out:
  do
    ;
  while (0);
  return 0;
}
static int __attribute__((__section__(".exit.text"))) __attribute__((__cold__))
__attribute__((no_instrument_function))
atmel_lcdfb_remove(struct platform_device *pdev) {
  struct device dev = pdev->dev;
  struct fb_info *info = dev_get_drvdata(&dev);
  atmel_lcdfb_power_control(info->par, 0);
  return 0;
}
struct fb_info atmel_lcdfb_suspend_info;
static int atmel_lcdfb_suspend(struct platform_device *pdev,
                               pm_message_t mesg) {
  struct atmel_lcdfb_info *sinfo = atmel_lcdfb_suspend_info.par;
  atmel_lcdfb_power_control(sinfo, 0);
  return 0;
}
struct fb_info *atmel_lcdfb_resume_info = 0;
static int atmel_lcdfb_resume(struct platform_device *pdev) {
  struct atmel_lcdfb_info *sinfo = atmel_lcdfb_resume_info->par;
  atmel_lcdfb_start_clock(sinfo);
  return 0;
}
static struct platform_driver atmel_lcdfb_driver = {
    .remove = atmel_lcdfb_remove,
    .suspend = atmel_lcdfb_suspend,
    .resume = atmel_lcdfb_resume,
    .id_table = atmel_lcdfb_devtypes};
void atmel_lcdfb_driver_init(void) {
  __platform_driver_probe(&atmel_lcdfb_driver, atmel_lcdfb_probe,
                          &__this_module);
}

--nextPart3227335.XSoIECOhKP--
