MIME-Version: 1.0
In-Reply-To: <201702170838.cW5onrBk%fengguang.wu@intel.com>
References: <20170216215438.126111-1-thgarnie@google.com> <201702170838.cW5onrBk%fengguang.wu@intel.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 17 Feb 2017 08:00:19 -0800
Message-ID: <CAJcbSZH7nyLuSmE2imEdk-VzwZcLw4P9T3jZEE2EiRUVPEbL1g@mail.gmail.com>
Content-Type: multipart/alternative; boundary=94eb2c111de8bd641d0548bc028e
Subject: [kernel-hardening] Re: [PATCH v4 1/4] x86/mm: Adapt MODULES_END based on Fixmap section size
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Lorenzo Stoakes <lstoakes@gmail.com>, Juergen Gross <jgross@suse.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm list <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c111de8bd641d0548bc028e
Content-Type: text/plain; charset=UTF-8

I will send an update patch on this thread to fix the fixmap dependencies.

On Thu, Feb 16, 2017 at 4:45 PM, kbuild test robot <lkp@intel.com> wrote:

> Hi Thomas,
>
> [auto build test ERROR on next-20170216]
> [also build test ERROR on v4.10-rc8]
> [cannot apply to tip/x86/core kvm/linux-next tip/auto-latest v4.9-rc8
> v4.9-rc7 v4.9-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to
> help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Thomas-Garnier/
> x86-mm-Adapt-MODULES_END-based-on-Fixmap-section-size/20170217-072759
> config: x86_64-randconfig-s4-02170325 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> All errors (new ones prefixed by >>):
>
>    In file included from arch/x86/include/asm/pgtable_types.h:240:0,
>                     from arch/x86/include/asm/paravirt_types.h:44,
>                     from arch/x86/include/asm/ptrace.h:71,
>                     from arch/x86/include/asm/math_emu.h:4,
>                     from arch/x86/include/asm/processor.h:11,
>                     from arch/x86/include/asm/cpufeature.h:4,
>                     from arch/x86/include/asm/thread_info.h:52,
>                     from include/linux/thread_info.h:25,
>                     from arch/x86/include/asm/preempt.h:6,
>                     from include/linux/preempt.h:59,
>                     from include/linux/spinlock.h:50,
>                     from include/linux/wait.h:8,
>                     from include/linux/fs.h:5,
>                     from include/linux/debugfs.h:18,
>                     from arch/x86/mm/dump_pagetables.c:15:
> >> arch/x86/include/asm/pgtable_64_types.h:71:23: error: implicit
> declaration of function '__fix_to_virt' [-Werror=implicit-function-
> declaration]
>     #define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
>                           ^
>    arch/x86/mm/dump_pagetables.c:87:4: note: in expansion of macro
> 'MODULES_END'
>      { MODULES_END,          "End Modules" },
>        ^~~~~~~~~~~
>    arch/x86/include/asm/pgtable_64_types.h:71:37: error:
> '__end_of_fixed_addresses' undeclared here (not in a function)
>     #define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
>                                         ^
>    arch/x86/mm/dump_pagetables.c:87:4: note: in expansion of macro
> 'MODULES_END'
>      { MODULES_END,          "End Modules" },
>        ^~~~~~~~~~~
>    cc1: some warnings being treated as errors
>
> vim +/__fix_to_virt +71 arch/x86/include/asm/pgtable_64_types.h
>
>     65  #define VMALLOC_START   __VMALLOC_BASE
>     66  #define VMEMMAP_START   __VMEMMAP_BASE
>     67  #endif /* CONFIG_RANDOMIZE_MEMORY */
>     68  #define VMALLOC_END     (VMALLOC_START + _AC((VMALLOC_SIZE_TB <<
> 40) - 1, UL))
>     69  #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
>     70  /* The module sections ends with the start of the fixmap */
>   > 71  #define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
>     72  #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
>     73  #define ESPFIX_PGD_ENTRY _AC(-2, UL)
>     74  #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation
>



-- 
Thomas

--94eb2c111de8bd641d0548bc028e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I will send an update patch on this thread to fix the fixm=
ap dependencies.</div><div class=3D"gmail_extra"><br><div class=3D"gmail_qu=
ote">On Thu, Feb 16, 2017 at 4:45 PM, kbuild test robot <span dir=3D"ltr">&=
lt;<a href=3D"mailto:lkp@intel.com" target=3D"_blank">lkp@intel.com</a>&gt;=
</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">Hi Thomas=
,<br>
<br>
[auto build test ERROR on next-20170216]<br>
[also build test ERROR on v4.10-rc8]<br>
[cannot apply to tip/x86/core kvm/linux-next tip/auto-latest v4.9-rc8 v4.9-=
rc7 v4.9-rc6]<br>
[if your patch is applied to the wrong git tree, please drop us a note to h=
elp improve the system]<br>
<br>
url:=C2=A0 =C2=A0 <a href=3D"https://github.com/0day-ci/linux/commits/Thoma=
s-Garnier/x86-mm-Adapt-MODULES_END-based-on-Fixmap-section-size/20170217-07=
2759" rel=3D"noreferrer" target=3D"_blank">https://github.com/0day-ci/<wbr>=
linux/commits/Thomas-Garnier/<wbr>x86-mm-Adapt-MODULES_END-<wbr>based-on-Fi=
xmap-section-size/<wbr>20170217-072759</a><br>
</span>config: x86_64-randconfig-s4-02170325 (attached as .config)<br>
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901<br>
<span class=3D"">reproduce:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # save the attached .config to linux build tree=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 make ARCH=3Dx86_64<br>
<br>
</span>All errors (new ones prefixed by &gt;&gt;):<br>
<span class=3D""><br>
=C2=A0 =C2=A0In file included from arch/x86/include/asm/pgtable_<wbr>types.=
h:240:0,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/include/asm/paravirt_<wbr>types.h:44,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/include/asm/ptrace.h:<wbr>71,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/include/asm/math_emu.<wbr>h:4,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/include/asm/<wbr>processor.h:11,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/include/asm/<wbr>cpufeature.h:4,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/include/asm/thread_<wbr>info.h:52,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/thread_info.h:<wbr>25,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/include/asm/preempt.<wbr>h:6,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/preempt.h:59,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/spinlock.h:50,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/wait.h:8,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/fs.h:5,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/debugfs.h:18,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/x86/mm/dump_pagetables.c:<wbr>15:<br>
</span>&gt;&gt; arch/x86/include/asm/pgtable_<wbr>64_types.h:71:23: error: =
implicit declaration of function &#39;__fix_to_virt&#39; [-Werror=3Dimplici=
t-function-<wbr>declaration]<br>
<span class=3D"">=C2=A0 =C2=A0 #define MODULES_END=C2=A0 =C2=A0__fix_to_vir=
t(__end_of_fixed_<wbr>addresses + 1)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 ^<br>
=C2=A0 =C2=A0arch/x86/mm/dump_pagetables.c:<wbr>87:4: note: in expansion of=
 macro &#39;MODULES_END&#39;<br>
=C2=A0 =C2=A0 =C2=A0{ MODULES_END,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;=
End Modules&quot; },<br>
</span>=C2=A0 =C2=A0 =C2=A0 =C2=A0^~~~~~~~~~~<br>
<span class=3D"">=C2=A0 =C2=A0arch/x86/include/asm/pgtable_<wbr>64_types.h:=
71:37: error: &#39;__end_of_fixed_addresses&#39; undeclared here (not in a =
function)<br>
=C2=A0 =C2=A0 #define MODULES_END=C2=A0 =C2=A0__fix_to_virt(__end_of_fixed_=
<wbr>addresses + 1)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^<br>
=C2=A0 =C2=A0arch/x86/mm/dump_pagetables.c:<wbr>87:4: note: in expansion of=
 macro &#39;MODULES_END&#39;<br>
=C2=A0 =C2=A0 =C2=A0{ MODULES_END,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;=
End Modules&quot; },<br>
</span>=C2=A0 =C2=A0 =C2=A0 =C2=A0^~~~~~~~~~~<br>
<span class=3D"">=C2=A0 =C2=A0cc1: some warnings being treated as errors<br=
>
<br>
</span>vim +/__fix_to_virt +71 arch/x86/include/asm/pgtable_<wbr>64_types.h=
<br>
<br>
=C2=A0 =C2=A0 65=C2=A0 #define VMALLOC_START=C2=A0 =C2=A0__VMALLOC_BASE<br>
=C2=A0 =C2=A0 66=C2=A0 #define VMEMMAP_START=C2=A0 =C2=A0__VMEMMAP_BASE<br>
=C2=A0 =C2=A0 67=C2=A0 #endif /* CONFIG_RANDOMIZE_MEMORY */<br>
=C2=A0 =C2=A0 68=C2=A0 #define VMALLOC_END=C2=A0 =C2=A0 =C2=A0(VMALLOC_STAR=
T + _AC((VMALLOC_SIZE_TB &lt;&lt; 40) - 1, UL))<br>
=C2=A0 =C2=A0 69=C2=A0 #define MODULES_VADDR=C2=A0 =C2=A0 (__START_KERNEL_m=
ap + KERNEL_IMAGE_SIZE)<br>
=C2=A0 =C2=A0 70=C2=A0 /* The module sections ends with the start of the fi=
xmap */<br>
=C2=A0 &gt; 71=C2=A0 #define MODULES_END=C2=A0 =C2=A0__fix_to_virt(__end_of=
_fixed_<wbr>addresses + 1)<br>
=C2=A0 =C2=A0 72=C2=A0 #define MODULES_LEN=C2=A0 =C2=A0(MODULES_END - MODUL=
ES_VADDR)<br>
=C2=A0 =C2=A0 73=C2=A0 #define ESPFIX_PGD_ENTRY _AC(-2, UL)<br>
=C2=A0 =C2=A0 74=C2=A0 #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY &lt;&lt; =
PGDIR_SHIFT)<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
---<br>
0-DAY kernel test infrastructure=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 Open Source Technology Center<br>
<a href=3D"https://lists.01.org/pipermail/kbuild-all" rel=3D"noreferrer" ta=
rget=3D"_blank">https://lists.01.org/<wbr>pipermail/kbuild-all</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Intel Corpora=
tion<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature" data-smartmail=3D"gmail_signature">Thomas</d=
iv>
</div>

--94eb2c111de8bd641d0548bc028e--
