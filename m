MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAGXu5jKNkBr=6uS58e08pimNb2v7Xf-YVGJ7aaHNV3pM859p5Q@mail.gmail.com>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org> <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
 <CAGXu5j+cd8iXAVko_fOFkPLD2Q=1=S0jvCYGAhKjnTunJ=86Zg@mail.gmail.com>
 <CAK8P3a2Xh3O3j6uAskVj8YHOK=sMNBGvR_o_jSN53RdQp7NyZg@mail.gmail.com> <CAGXu5jKNkBr=6uS58e08pimNb2v7Xf-YVGJ7aaHNV3pM859p5Q@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 28 Mar 2017 22:31:09 +0200
Message-ID: <CAK8P3a0OAOM-4C5Qh+CGacz0XEN2L0EDbTQT5ch+Q_+RMc8xSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v5 1/4] gcc-plugins: Add the initify
 gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 28, 2017 at 9:03 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Mar 28, 2017 at 12:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Mon, Mar 27, 2017 at 6:14 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Mon, Mar 27, 2017 at 12:38 AM, Andrew Donnellan
>>> <andrew.donnellan@au1.ibm.com> wrote:
>>>> On 01/02/17 07:24, Kees Cook wrote:
>>>>>
>>>>> From: Emese Revfy <re.emese@gmail.com>
>>>>>
>>>>> The kernel already has a mechanism to free up code and data memory that
>>>>> is only used during kernel or module initialization.  This plugin will
>>>>> teach the compiler to find more such code and data that can be freed
>>>>> after initialization.
>>>>
>>>>
>>>> Currently checking whether we can wire this up for powerpc without too many
>>>> problems...
>>>
>>> Cool, thanks. FWIW, note that this plugin is a bit back-burnered at
>>> the moment. I've got this in my -next tree still, but it needs some
>>> rather large changes to how it does its annotations before Linus will
>>> accept it.
>>
>> I've tried turning it on again a few days ago and still got too many build
>> problems with my randconfig tree, so I've turned it off again. I think I've
>> already reported most of what I found now, so I did not send out new
>> reports.
>
> Hrm, with what's in -next? That's too bad. I thought everything you
> reported had been fixed. Dang. :(

Here are the ones I'm still getting with around 50 randconfig builds:

0xA1433C1D Tue Mar 28 21:43:01 CEST 2017 failed
/git/arm-soc/drivers/acpi/acpica/utdebug.c: In function 'acpi_debug_print':
/git/arm-soc/drivers/acpi/acpica/utdebug.c:158:1: error:
'acpi_debug_print' captures its 3 ('function_name') parameter, please
remove it from the nocapture attribute. [-Werror]

0x46D10F38 Tue Mar 28 21:48:11 CEST 2017 failed
/git/arm-soc/lib/string.c: In function 'check_bytes8':
/git/arm-soc/lib/string.c:900:7: error: 'check_bytes8' captures its 1
('start') parameter, please remove it from the nocapture attribute.
[-Werror]
 void *check_bytes8(const u8 *start, u8 value, unsigned int bytes)
       ^~~~~~~~~~~~
0xDC65C29E Tue Mar 28 22:20:43 CEST 2017 success
0xCF5F679E Tue Mar 28 22:21:02 CEST 2017 failed
/git/arm-soc/lib/string.c: In function 'strnstr':
/git/arm-soc/lib/string.c:858:7: error: 'strnstr' captures its 1
('s1') parameter, please remove it from the nocapture attribute.
[-Werror]

I also got this a few days ago:

*** WARNING *** there are active plugins, do not report this as a bug
unless you can reproduce it without enabling any plugins.
Event                            | Plugins
PLUGIN_ATTRIBUTES                | initify_plugin
PLUGIN_START_UNIT                | initify_plugin
/git/arm-soc/arch/arm/mach-mv78xx0/common.c: In function 'mv78xx0_init':
/git/arm-soc/arch/arm/mach-mv78xx0/common.c:384:13: internal compiler
error: in search_constant_strings, at
git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
 void __init mv78xx0_init(void)
             ^~~~~~~~~~~~
0x2b0538381b9d search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
0x2b0538381950 search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1335
0x2b0538381950 search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1367
0x2b0538382abe search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1506
0x2b0538382abe search_var_param
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1419
0x2b0538382abe search_const_strs
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1471
0x2b0538382abe initify_function_transform
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1519
0xc679a3 execute_one_ipa_transform_pass
/home/arnd/git/gcc/gcc/passes.c:2207
0xc67b2d execute_all_ipa_transforms()
/home/arnd/git/gcc/gcc/passes.c:2249
0x8d5a46 cgraph_node::expand()
/home/arnd/git/gcc/gcc/cgraphunit.c:2029
0x8d5f1c expand_all_functions
/home/arnd/git/gcc/gcc/cgraphunit.c:2172
0x8d69ec symbol_table::compile()
/home/arnd/git/gcc/gcc/cgraphunit.c:2529
0x8d6c2c symbol_table::finalize_compilation_unit()
/home/arnd/git/gcc/gcc/cgraphunit.c:2619
Please submit a full bug report,
with preprocessed source if appropriate.
Please include the complete backtrace with any bug report.
See <http://gcc.gnu.org/bugs.html> for instructions.
/git/arm-soc/scripts/Makefile.build:308: recipe for target
'arch/arm/mach-mv78xx0/common.o' failed


     Arnd
