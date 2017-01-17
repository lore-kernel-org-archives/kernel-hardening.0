Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170116115435.GB5908@leverpostej>
References: <20170113220256.GA57663@beast> <20170116115435.GB5908@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 17 Jan 2017 09:56:24 -0800
Message-ID: <CAGXu5j+GQ5feC=bL4-PKWV9p3e9CeAKKGMfgdwk1=FfnYLMviw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: Mark Rutland <mark.rutland@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 3:54 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> [adding Dave, so retaining full context below]
>
> On Fri, Jan 13, 2017 at 02:02:56PM -0800, Kees Cook wrote:
>> This plugin detects any structures that contain __user attributes and
>> makes sure it is being fulling initialized so that a specific class of
>
> Nit: s/fulling/fully/

Whoops, thanks, fixed.

>> information exposure is eliminated. (For example, the exposure of siginf=
o
>> in CVE-2013-2141 would have been blocked by this plugin.)
>>
>> Ported from grsecurity/PaX. This version adds a verbose option to the
>> plugin and the Kconfig.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/Kconfig                            |  22 +++
>>  include/linux/compiler.h                |   6 +-
>>  scripts/Makefile.gcc-plugins            |   4 +
>>  scripts/gcc-plugins/structleak_plugin.c | 246 +++++++++++++++++++++++++=
+++++++
>>  4 files changed, 277 insertions(+), 1 deletion(-)
>>  create mode 100644 scripts/gcc-plugins/structleak_plugin.c
>
> I tried giving this a go, but I got the build failure below:
>
> ----
> [mark@leverpostej:~/src/linux]% uselinaro 15.08 make ARCH=3Darm64 CROSS_C=
OMPILE=3Daarch64-linux-gnu-
> arch/arm64/Makefile:43: Detected assembler with broken .inst; disassembly=
 will be unreliable
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   HOSTCXX -fPIC scripts/gcc-plugins/structleak_plugin.o
> scripts/gcc-plugins/structleak_plugin.c: In function =E2=80=98int plugin_=
init(plugin_name_args*, plugin_gcc_version*)=E2=80=99:
> scripts/gcc-plugins/structleak_plugin.c:214:12: error: =E2=80=98structlea=
k=E2=80=99 was not declared in this scope
>   PASS_INFO(structleak, "early_optimizations", 1, PASS_POS_INSERT_BEFORE)=
;
>             ^

Sorry, yes, this depends on the gcc-plugins changes in -next.

> [...]
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 99839c23d453..f1250ba0b06f 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -410,6 +410,28 @@ config GCC_PLUGIN_LATENT_ENTROPY
>>          * https://grsecurity.net/
>>          * https://pax.grsecurity.net/
>>
>> +config GCC_PLUGIN_STRUCTLEAK
>> +     bool "Force initialization of variables containing userspace addre=
sses"
>> +     depends on GCC_PLUGINS
>> +     help
>> +       This plugin zero-initializes any structures that containing a
>> +       __user attribute. This can prevent some classes of information
>> +       exposures.
>> +
>> +       This plugin was ported from grsecurity/PaX. More information at:
>> +        * https://grsecurity.net/
>> +        * https://pax.grsecurity.net/
>> +
>> +config GCC_PLUGIN_STRUCTLEAK_VERBOSE
>> +     bool "Report initialized variables"
>
> It might be better to say "Report forcefully initialized variables", to m=
ake it
> clear that this is only reporting initialization performed by the plugin.

Sounds good, changed.

> [...]
>> +     /* these aren't the 0days you're looking for */
>> +     if (verbose)
>> +             inform(DECL_SOURCE_LOCATION(var),
>> +                     "userspace variable will be forcibly initialized")=
;
>> +
>> +     /* build the initializer expression */
>> +     initializer =3D build_constructor(TREE_TYPE(var), NULL);
>> +
>> +     /* build the initializer stmt */
>> +     init_stmt =3D gimple_build_assign(var, initializer);
>> +     gsi =3D gsi_after_labels(single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun))=
);
>> +     gsi_insert_before(&gsi, init_stmt, GSI_NEW_STMT);
>> +     update_stmt(init_stmt);
>
> I assume that this is only guaranteed to initialise fields in a struct,
> and not padding, is that correct? I ask due to the issue described in:
>
> https://lwn.net/Articles/417989/
>
> As a further step, it would be interesting to see if we could fix
> padding for __user variables, but that certainly shouldn't hold this
> back.

This spawned a whole thread. :) For non-C11, yeah, a plugin to do this
would be nice. That's already on the KSPP TODO list, but from what I
can tell it either requires walking every variable's structure to
check for sizes and padding or do explicitly add a constructor for
every variable and hope that the optimization phase does the right
thing. ;)

>> +}
>> +
>> +static unsigned int structleak_execute(void)
>> +{
>> +     basic_block bb;
>> +     unsigned int ret =3D 0;
>> +     tree var;
>> +     unsigned int i;
>> +
>> +     /* split the first bb where we can put the forced initializers */
>> +     gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
>> +     bb =3D single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
>> +     if (!single_pred_p(bb)) {
>> +             split_edge(single_succ_edge(ENTRY_BLOCK_PTR_FOR_FN(cfun)))=
;
>> +             gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
>> +     }
>> +
>> +     /* enumarate all local variables and forcibly initialize our targe=
ts */
>
> Nit: s/enumarate/enumerate/

Fixed.

Thanks for the review!

-Kees

--=20
Kees Cook
Nexus Security
