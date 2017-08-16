References: <20170816224650.1089-1-labbott@redhat.com>
 <20170816224650.1089-3-labbott@redhat.com>
 <CAGXu5j+pTNqoHC16LkJ5QLKHeAn6hsCcBMCk36jvd34Jd9Svtg@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <7e62d7c5-0aa1-06ed-4086-028ca39e9ce1@redhat.com>
Date: Wed, 16 Aug 2017 15:53:23 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+pTNqoHC16LkJ5QLKHeAn6hsCcBMCk36jvd34Jd9Svtg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv2 2/2] extract early boot entropy from the passed cmdline
To: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 08/16/2017 03:48 PM, Kees Cook wrote:
> On Wed, Aug 16, 2017 at 3:46 PM, Laura Abbott <labbott@redhat.com> wrote:
>> From: Daniel Micay <danielmicay@gmail.com>
>>
>> Existing Android bootloaders usually pass data useful as early entropy
>> on the kernel command-line. It may also be the case on other embedded
>> systems. Sample command-line from a Google Pixel running CopperheadOS:
>>
>>     console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0
>>     androidboot.hardware=sailfish user_debug=31 ehci-hcd.park=3
>>     lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff buildvariant=user
>>     veritykeyid=id:dfcb9db0089e5b3b4090a592415c28e1cb4545ab
>>     androidboot.bootdevice=624000.ufshc androidboot.verifiedbootstate=yellow
>>     androidboot.veritymode=enforcing androidboot.keymaster=1
>>     androidboot.serialno=FA6CE0305299 androidboot.baseband=msm
>>     mdss_mdp.panel=1:dsi:0:qcom,mdss_dsi_samsung_ea8064tg_1080p_cmd:1:none:cfg:single_dsi
>>     androidboot.slot_suffix=_b fpsimd.fpsimd_settings=0
>>     app_setting.use_app_setting=0 kernelflag=0x00000000 debugflag=0x00000000
>>     androidboot.hardware.revision=PVT radioflag=0x00000000
>>     radioflagex1=0x00000000 radioflagex2=0x00000000 cpumask=0x00000000
>>     androidboot.hardware.ddr=4096MB,Hynix,LPDDR4 androidboot.ddrinfo=00000006
>>     androidboot.ddrsize=4GB androidboot.hardware.color=GRA00
>>     androidboot.hardware.ufs=32GB,Samsung androidboot.msm.hw_ver_id=268824801
>>     androidboot.qf.st=2 androidboot.cid=11111111 androidboot.mid=G-2PW4100
>>     androidboot.bootloader=8996-012001-1704121145
>>     androidboot.oem_unlock_support=1 androidboot.fp_src=1
>>     androidboot.htc.hrdump=detected androidboot.ramdump.opt=mem@2g:2g,mem@4g:2g
>>     androidboot.bootreason=reboot androidboot.ramdump_enable=0 ro
>>     root=/dev/dm-0 dm="system none ro,0 1 android-verity /dev/sda34"
>>     rootwait skip_initramfs init=/init androidboot.wificountrycode=US
>>     androidboot.boottime=1BLL:85,1BLE:669,2BLL:0,2BLE:1777,SW:6,KL:8136
>>
>> Among other things, it contains a value unique to the device
>> (androidboot.serialno=FA6CE0305299), unique to the OS builds for the
>> device variant (veritykeyid=id:dfcb9db0089e5b3b4090a592415c28e1cb4545ab)
>> and timings from the bootloader stages in milliseconds
>> (androidboot.boottime=1BLL:85,1BLE:669,2BLL:0,2BLE:1777,SW:6,KL:8136).
>>
>> Signed-off-by: Daniel Micay <danielmicay@gmail.com>
>> [labbott: Line-wrapped command line]
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>  init/main.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/init/main.c b/init/main.c
>> index 21d599eaad06..cb051aec46ef 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -533,6 +533,7 @@ asmlinkage __visible void __init start_kernel(void)
>>          */
>>         add_latent_entropy();
>>         boot_init_stack_canary();
>> +       add_device_randomness(command_line, strlen(command_line));
> 
> This should be above the add_latent_entropy() line there so the
> cmdline entropy can contribute to the canary entropy.
> 

Yeah, bad merge on my fault. Will spin a v3.

> -Kees
> 
>>         mm_init_cpumask(&init_mm);
>>         setup_command_line(command_line);
>>         setup_nr_cpu_ids();
>> --
>> 2.13.0
>>
> 
> 
> 
