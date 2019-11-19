Return-Path: <SRS0=DByl=ZL=lists.openwall.com=kernel-hardening-return-17401-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF6DC432C0
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 21:52:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 629CE2244A
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 21:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="KcX5BxpB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 629CE2244A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17401-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21753 invoked by uid 550); 19 Nov 2019 21:52:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21730 invoked from network); 19 Nov 2019 21:52:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=U+SbCq3ocNyIo8FGHGBsSRQOyqzMfc7Ayipxb/773i8=;
        b=KcX5BxpBvCiVa5obG46C4S3He8tf3OTP3Bosy1rZ40/JcilaiK1Qp7vtJFf8FecVhj
         FkGDrmQhiII+OxUHVxYjmq9y0NdMZfJyYFRgUqcJ+81xRnzeoqzPQYjcPjVGG2Bb7GP/
         6Lk/SophoJYhXwO+VaBH5Lh8emWMoPzR06Cw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=U+SbCq3ocNyIo8FGHGBsSRQOyqzMfc7Ayipxb/773i8=;
        b=DxPzWRoSGV2EUniBxs1EZswl0A3IYXCVnBsZLojjsjkH0iBBNPODzHJzbrqNPsxQHs
         mWEZx7WqDw5LDTmp5k28npdzvvfvttaCO9bGki0D2B0sV5rl2HuGY5ioQYZmpvlJeDl9
         3K53AZQPUqTZ5vHllsFCeyvPhHSlhePEgOs1NxpJk9mnoKYM/0GlsgPTsWx4jOrOAeSl
         IG3id2R1XIFjudYFMQlOiuStucLAb+d//Vzqu0ET5JCwDA00vGgnfkQqFOokb/Jyu1Xj
         VCCa8MIcTu2044ckE13RyTpfF+lT1vTj4mNIiHTHLs1OCBXIH6rPgLIkE6CRQEVXngmm
         r1bg==
X-Gm-Message-State: APjAAAXYiGl/oOj0yPdKazuCLvJbY+8uxtXlyCXbkau/WjWOa164B1JI
	KvxYMazePkty8c9wIl2jnjxw
X-Google-Smtp-Source: APXvYqwbMonlNXEBTlC6fuNAVLqY1dMdsThFjtpsB2CKiUHG/J/14xV5j3VhfSfRlbbsM4wAchm2Lg==
X-Received: by 2002:a17:902:a516:: with SMTP id s22mr29120783plq.295.1574200316220;
        Tue, 19 Nov 2019 13:51:56 -0800 (PST)
From: Tianlin Li <tli@digitalocean.com>
Message-Id: <180F067D-0E86-479C-942A-E1E9118D3431@digitalocean.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_96CC2F9E-A2F9-4977-908B-8F533F03F8D0"
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC PATCH] kernel/module: have the callers of set_memory_*()
 check the return value
Date: Tue, 19 Nov 2019 15:51:52 -0600
In-Reply-To: <201911190849.131691D@keescook>
Cc: kernel-hardening@lists.openwall.com,
 Steven Rostedt <rostedt@goodmis.org>,
 Ingo Molnar <mingo@redhat.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Greentime Hu <green.hu@gmail.com>,
 Vincent Chen <deanbo422@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>,
 "H . Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org,
 Jessica Yu <jeyu@kernel.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
To: Kees Cook <keescook@chromium.org>
References: <20191119155149.20396-1-tli@digitalocean.com>
 <201911190849.131691D@keescook>
X-Mailer: Apple Mail (2.3445.104.11)


--Apple-Mail=_96CC2F9E-A2F9-4977-908B-8F533F03F8D0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Nov 19, 2019, at 11:07 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
> On Tue, Nov 19, 2019 at 09:51:49AM -0600, Tianlin Li wrote:
>> Right now several architectures allow their set_memory_*() family of=20=

>> functions to fail, but callers may not be checking the return values. =
We=20
>> need to fix the callers and add the __must_check attribute. They also =
may
>> not provide any level of atomicity, in the sense that the memory=20
>> protections may be left incomplete on failure. This issue likely has =
a few=20
>> steps on effects architectures[1]:
>=20
> Awesome; thanks for working on this!
>=20
> A few suggestions on this patch, which will help reviewers, below...
>=20
>> 1)Have all callers of set_memory_*() helpers check the return value.
>> 2)Add __much_check to all set_memory_*() helpers so that new uses do =
not=20
>> ignore the return value.
>> 3)Add atomicity to the calls so that the memory protections aren't =
left in=20
>> a partial state.
>=20
> Maybe clarify to say something like "this series is step 1=E2=80=9D?
ok. Will add the clarification. Thanks!
>=20
>>=20
>> Ideally, the failure of set_memory_*() should be passed up the call =
stack,=20
>> and callers should examine the failure and deal with it. But =
currently,=20
>> some callers just have void return type.
>>=20
>> We need to fix the callers to handle the return all the way to the =
top of=20
>> stack, and it will require a large series of patches to finish all =
the three=20
>> steps mentioned above. I start with kernel/module, and will move onto =
other=20
>> subsystems. I am not entirely sure about the failure modes for each =
caller.=20
>> So I would like to get some comments before I move forward. This =
single=20
>> patch is just for fixing the return value of set_memory_*() function =
in=20
>> kernel/module, and also the related callers. Any feedback would be =
greatly=20
>> appreciated.
>>=20
>> [1]:https://github.com/KSPP/linux/issues/7
>>=20
>> Signed-off-by: Tianlin Li <tli@digitalocean.com>
>> ---
>> arch/arm/kernel/ftrace.c   |   8 +-
>> arch/arm64/kernel/ftrace.c |   6 +-
>> arch/nds32/kernel/ftrace.c |   6 +-
>> arch/x86/kernel/ftrace.c   |  13 ++-
>> include/linux/module.h     |  16 ++--
>> kernel/livepatch/core.c    |  15 +++-
>> kernel/module.c            | 170 =
+++++++++++++++++++++++++++----------
>> kernel/trace/ftrace.c      |  15 +++-
>> 8 files changed, 175 insertions(+), 74 deletions(-)
>=20
> - Can you break this patch into 3 separate patches, by "subsystem":
> 	- ftrace
> 	- module
> 	- livepatch (unless Jessica thinks maybe livepatch should go
> 	  with module?)
> - Please run patches through scripts/checkpatch.pl to catch common
>  coding style issues (e.g. blank line between variable declarations
>  and function body).
> - These changes look pretty straight forward, so I think it'd be fine
>  to drop the "RFC" tag and include linux-kernel@vger.kernel.org =
<mailto:linux-kernel@vger.kernel.org> in the
>  Cc list for the v2. For lots of detail, see:
>  =
https://www.kernel.org/doc/html/latest/process/submitting-patches.html =
<https://www.kernel.org/doc/html/latest/process/submitting-patches.html>

ok. I will fix them in v2. Thanks a lot!=20
> More below...
>=20
>>=20
>> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
>> index bda949fd84e8..7ea1338821d6 100644
>> --- a/arch/arm/kernel/ftrace.c
>> +++ b/arch/arm/kernel/ftrace.c
>> @@ -59,13 +59,15 @@ static unsigned long adjust_address(struct =
dyn_ftrace *rec, unsigned long addr)
>>=20
>> int ftrace_arch_code_modify_prepare(void)
>> {
>> -	set_all_modules_text_rw();
>> -	return 0;
>> +	return set_all_modules_text_rw();
>> }
>>=20
>> int ftrace_arch_code_modify_post_process(void)
>> {
>> -	set_all_modules_text_ro();
>> +	int ret;
>=20
> Blank line here...
>=20
>> +	ret =3D set_all_modules_text_ro();
>> +	if (ret)
>> +		return ret;
>> 	/* Make sure any TLB misses during machine stop are cleared. */
>> 	flush_tlb_all();
>> 	return 0;
>=20
> Are callers of these ftrace functions checking return values too?
ftrace_arch_code_modify_prepare is called in ftrace_run_update_code and =
ftrace_module_enable.=20
ftrace_run_update_code is checking the return value of =
ftrace_arch_code_modify_prepare already.=20
ftrace_module_enable didn=E2=80=99t check. (I modifies this function in =
this patch to check the return value of ftrace_arch_code_modify_prepare =
).=20
Same for ftrace_arch_code_modify_post_process.=20

>> diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
>> index 171773257974..97a89c38f6b9 100644
>> --- a/arch/arm64/kernel/ftrace.c
>> +++ b/arch/arm64/kernel/ftrace.c
>> @@ -115,9 +115,11 @@ int ftrace_make_call(struct dyn_ftrace *rec, =
unsigned long addr)
>> 			}
>>=20
>> 			/* point the trampoline to our ftrace entry =
point */
>> -			module_disable_ro(mod);
>> +			if (module_disable_ro(mod))
>> +				return -EINVAL;
>> 			*dst =3D trampoline;
>> -			module_enable_ro(mod, true);
>> +			if (module_enable_ro(mod, true))
>> +				return -EINVAL;
>>=20
>> 			/*
>> 			 * Ensure updated trampoline is visible to =
instruction
>> diff --git a/arch/nds32/kernel/ftrace.c b/arch/nds32/kernel/ftrace.c
>> index fd2a54b8cd57..e9e63e703a3e 100644
>> --- a/arch/nds32/kernel/ftrace.c
>> +++ b/arch/nds32/kernel/ftrace.c
>> @@ -91,14 +91,12 @@ int __init ftrace_dyn_arch_init(void)
>>=20
>> int ftrace_arch_code_modify_prepare(void)
>> {
>> -	set_all_modules_text_rw();
>> -	return 0;
>> +	return set_all_modules_text_rw();
>> }
>>=20
>> int ftrace_arch_code_modify_post_process(void)
>> {
>> -	set_all_modules_text_ro();
>> -	return 0;
>> +	return set_all_modules_text_ro();
>> }
>>=20
>> static unsigned long gen_sethi_insn(unsigned long addr)
>> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
>> index 024c3053dbba..7fdee06e2a76 100644
>> --- a/arch/x86/kernel/ftrace.c
>> +++ b/arch/x86/kernel/ftrace.c
>> @@ -42,19 +42,26 @@ int ftrace_arch_code_modify_prepare(void)
>> 	 * and live kernel patching from changing the text permissions =
while
>> 	 * ftrace has it set to "read/write".
>> 	 */
>> +	int ret;
>> 	mutex_lock(&text_mutex);
>> 	set_kernel_text_rw();
>> -	set_all_modules_text_rw();
>> +	ret =3D set_all_modules_text_rw();
>> +	if (ret) {
>> +		set_kernel_text_ro();
>=20
> Is the set_kernel_text_ro() here is an atomicity fix? Also, won't a =
future
> patch need to check the result of that function call? (i.e. should it
> be left out of this series and should atomicity fixes happen inside =
the
> set_memory_*() functions? Can they happen there?)
set_kernel_text_tro() here was not for an atomicity fix in step 3, it =
was just for reverting the status=20
in ftrace_arch_code_modify_prepare, because set_kernel_text_rw() is =
called.=20
Thanks for pointing it out.  I will check it.=20
>=20
>> +		mutex_unlock(&text_mutex);
>> +		return ret;
>> +	}
>> 	return 0;
>> }
>>=20
>> int ftrace_arch_code_modify_post_process(void)
>>     __releases(&text_mutex)
>> {
>> -	set_all_modules_text_ro();
>> +	int ret;
>=20
> blank line needed...
>=20
>> +	ret =3D set_all_modules_text_ro();
>> 	set_kernel_text_ro();
>> 	mutex_unlock(&text_mutex);
>> -	return 0;
>> +	return ret;
>> }
>>=20
>> union ftrace_code_union {
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 1455812dd325..e6c7f3b719a3 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -847,15 +847,15 @@ extern int module_sysfs_initialized;
>> #define __MODULE_STRING(x) __stringify(x)
>>=20
>> #ifdef CONFIG_STRICT_MODULE_RWX
>> -extern void set_all_modules_text_rw(void);
>> -extern void set_all_modules_text_ro(void);
>> -extern void module_enable_ro(const struct module *mod, bool =
after_init);
>> -extern void module_disable_ro(const struct module *mod);
>> +extern int set_all_modules_text_rw(void);
>> +extern int set_all_modules_text_ro(void);
>> +extern int module_enable_ro(const struct module *mod, bool =
after_init);
>> +extern int module_disable_ro(const struct module *mod);
>> #else
>> -static inline void set_all_modules_text_rw(void) { }
>> -static inline void set_all_modules_text_ro(void) { }
>> -static inline void module_enable_ro(const struct module *mod, bool =
after_init) { }
>> -static inline void module_disable_ro(const struct module *mod) { }
>> +static inline int set_all_modules_text_rw(void) { return 0; }
>> +static inline int set_all_modules_text_ro(void) { return 0; }
>> +static inline int module_enable_ro(const struct module *mod, bool =
after_init) { return 0; }
>=20
> Please wrap this line (yes, the old one wasn't...)
>=20
>> +static inline int module_disable_ro(const struct module *mod) { =
return 0; }
>> #endif
>>=20
>> #ifdef CONFIG_GENERIC_BUG
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index c4ce08f43bd6..39bfc0685854 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -721,16 +721,25 @@ static int klp_init_object_loaded(struct =
klp_patch *patch,
>>=20
>> 	mutex_lock(&text_mutex);
>>=20
>> -	module_disable_ro(patch->mod);
>> +	ret =3D module_disable_ro(patch->mod);
>> +	if (ret) {
>> +		mutex_unlock(&text_mutex);
>> +		return ret;
>> +	}
>> 	ret =3D klp_write_object_relocations(patch->mod, obj);
>> 	if (ret) {
>> -		module_enable_ro(patch->mod, true);
>> +		if (module_enable_ro(patch->mod, true));
>> +			pr_err("module_enable_ro failed.\n");
>=20
> Why the pr_err() here and not in other failure cases? (Also, should it
> instead be a WARN_ONCE() inside the set_memory_*() functions instead?)
Because module_enable_ro() is called in the checking of another return =
value. I can not return the value, so I print the error.=20
Similar to the previous question, should it be fixed by atomicity =
patches later?=20
>=20
>> 		mutex_unlock(&text_mutex);
>> 		return ret;
>> 	}
>>=20
>> 	arch_klp_init_object_loaded(patch, obj);
>> -	module_enable_ro(patch->mod, true);
>> +	ret =3D module_enable_ro(patch->mod, true);
>> +	if (ret) {
>> +		mutex_unlock(&text_mutex);
>> +		return ret;
>> +	}
>>=20
>> 	mutex_unlock(&text_mutex);
>>=20
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 9ee93421269c..87125b5e315c 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1900,111 +1900,162 @@ static void mod_sysfs_teardown(struct =
module *mod)
>>  *
>>  * These values are always page-aligned (as is base)
>>  */
>> -static void frob_text(const struct module_layout *layout,
>> +static int frob_text(const struct module_layout *layout,
>> 		      int (*set_memory)(unsigned long start, int =
num_pages))
>> {
>> 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
>> 	BUG_ON((unsigned long)layout->text_size & (PAGE_SIZE-1));
>> -	set_memory((unsigned long)layout->base,
>> +	return set_memory((unsigned long)layout->base,
>> 		   layout->text_size >> PAGE_SHIFT);
>> }
>>=20
>> #ifdef CONFIG_STRICT_MODULE_RWX
>> -static void frob_rodata(const struct module_layout *layout,
>> +static int frob_rodata(const struct module_layout *layout,
>> 			int (*set_memory)(unsigned long start, int =
num_pages))
>> {
>> 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
>> 	BUG_ON((unsigned long)layout->text_size & (PAGE_SIZE-1));
>> 	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
>> -	set_memory((unsigned long)layout->base + layout->text_size,
>> +	return set_memory((unsigned long)layout->base + =
layout->text_size,
>> 		   (layout->ro_size - layout->text_size) >> PAGE_SHIFT);
>> }
>>=20
>> -static void frob_ro_after_init(const struct module_layout *layout,
>> +static int frob_ro_after_init(const struct module_layout *layout,
>> 				int (*set_memory)(unsigned long start, =
int num_pages))
>> {
>> 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
>> 	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
>> 	BUG_ON((unsigned long)layout->ro_after_init_size & =
(PAGE_SIZE-1));
>> -	set_memory((unsigned long)layout->base + layout->ro_size,
>> +	return set_memory((unsigned long)layout->base + layout->ro_size,
>> 		   (layout->ro_after_init_size - layout->ro_size) >> =
PAGE_SHIFT);
>> }
>>=20
>> -static void frob_writable_data(const struct module_layout *layout,
>> +static int frob_writable_data(const struct module_layout *layout,
>> 			       int (*set_memory)(unsigned long start, =
int num_pages))
>> {
>> 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
>> 	BUG_ON((unsigned long)layout->ro_after_init_size & =
(PAGE_SIZE-1));
>> 	BUG_ON((unsigned long)layout->size & (PAGE_SIZE-1));
>> -	set_memory((unsigned long)layout->base + =
layout->ro_after_init_size,
>> +	return set_memory((unsigned long)layout->base + =
layout->ro_after_init_size,
>> 		   (layout->size - layout->ro_after_init_size) >> =
PAGE_SHIFT);
>> }
>>=20
>> /* livepatching wants to disable read-only so it can frob module. */
>> -void module_disable_ro(const struct module *mod)
>> +int module_disable_ro(const struct module *mod)
>> {
>> +	int ret;
>> 	if (!rodata_enabled)
>> -		return;
>> +		return 0;
>>=20
>> -	frob_text(&mod->core_layout, set_memory_rw);
>> -	frob_rodata(&mod->core_layout, set_memory_rw);
>> -	frob_ro_after_init(&mod->core_layout, set_memory_rw);
>> -	frob_text(&mod->init_layout, set_memory_rw);
>> -	frob_rodata(&mod->init_layout, set_memory_rw);
>> +	ret =3D frob_text(&mod->core_layout, set_memory_rw);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_rodata(&mod->core_layout, set_memory_rw);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_ro_after_init(&mod->core_layout, set_memory_rw);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_text(&mod->init_layout, set_memory_rw);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_rodata(&mod->init_layout, set_memory_rw);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> }
>>=20
>> -void module_enable_ro(const struct module *mod, bool after_init)
>> +int module_enable_ro(const struct module *mod, bool after_init)
>> {
>> +	int ret;
>> 	if (!rodata_enabled)
>> -		return;
>> +		return 0;
>>=20
>> 	set_vm_flush_reset_perms(mod->core_layout.base);
>> 	set_vm_flush_reset_perms(mod->init_layout.base);
>> -	frob_text(&mod->core_layout, set_memory_ro);
>> +	ret =3D frob_text(&mod->core_layout, set_memory_ro);
>> +	if (ret)
>> +		return ret;
>>=20
>> -	frob_rodata(&mod->core_layout, set_memory_ro);
>> -	frob_text(&mod->init_layout, set_memory_ro);
>> -	frob_rodata(&mod->init_layout, set_memory_ro);
>> +	ret =3D frob_rodata(&mod->core_layout, set_memory_ro);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_text(&mod->init_layout, set_memory_ro);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_rodata(&mod->init_layout, set_memory_ro);
>> +	if (ret)
>> +		return ret;
>>=20
>> -	if (after_init)
>> -		frob_ro_after_init(&mod->core_layout, set_memory_ro);
>> +	if (after_init) {
>> +		ret =3D frob_ro_after_init(&mod->core_layout, =
set_memory_ro);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +	return 0;
>> }
>>=20
>> -static void module_enable_nx(const struct module *mod)
>> +static int module_enable_nx(const struct module *mod)
>> {
>> -	frob_rodata(&mod->core_layout, set_memory_nx);
>> -	frob_ro_after_init(&mod->core_layout, set_memory_nx);
>> -	frob_writable_data(&mod->core_layout, set_memory_nx);
>> -	frob_rodata(&mod->init_layout, set_memory_nx);
>> -	frob_writable_data(&mod->init_layout, set_memory_nx);
>> +	int ret;
>> +
>> +	ret =3D frob_rodata(&mod->core_layout, set_memory_nx);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_ro_after_init(&mod->core_layout, set_memory_nx);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_writable_data(&mod->core_layout, set_memory_nx);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_rodata(&mod->init_layout, set_memory_nx);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_writable_data(&mod->init_layout, set_memory_nx);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> }
>>=20
>> /* Iterate through all modules and set each module's text as RW */
>> -void set_all_modules_text_rw(void)
>> +int set_all_modules_text_rw(void)
>> {
>> 	struct module *mod;
>> +	int ret;
>>=20
>> 	if (!rodata_enabled)
>> -		return;
>> +		return 0;
>>=20
>> 	mutex_lock(&module_mutex);
>> 	list_for_each_entry_rcu(mod, &modules, list) {
>> 		if (mod->state =3D=3D MODULE_STATE_UNFORMED)
>> 			continue;
>>=20
>> -		frob_text(&mod->core_layout, set_memory_rw);
>> -		frob_text(&mod->init_layout, set_memory_rw);
>> +		ret =3D frob_text(&mod->core_layout, set_memory_rw);
>> +		if (ret) {
>> +			mutex_unlock(&module_mutex);
>> +			return ret;
>> +		}
>> +		ret =3D frob_text(&mod->init_layout, set_memory_rw);
>> +		if (ret) {
>> +			mutex_unlock(&module_mutex);
>> +			return ret;
>> +		}
>=20
> This pattern feels like it might be better with a "goto out" style:
>=20
> 	mutex_lock...
> 	list_for_each... {
> 		ret =3D frob_...
> 		if (ret)
> 			goto out;
> 		ret =3D frob_...
> 		if (ret)
> 			goto out;
> 	}
> 	ret =3D 0;
> out:
> 	mutex_unlock...
> 	return ret;

Thanks! Will fix it in v2.=20
>=20
>> 	}
>> 	mutex_unlock(&module_mutex);
>> +	return 0;
>> }
>>=20
>> /* Iterate through all modules and set each module's text as RO */
>> -void set_all_modules_text_ro(void)
>> +int set_all_modules_text_ro(void)
>> {
>> 	struct module *mod;
>> +	int ret;
>>=20
>> 	if (!rodata_enabled)
>> -		return;
>> +		return 0;
>>=20
>> 	mutex_lock(&module_mutex);
>> 	list_for_each_entry_rcu(mod, &modules, list) {
>> @@ -2017,22 +2068,37 @@ void set_all_modules_text_ro(void)
>> 			mod->state =3D=3D MODULE_STATE_GOING)
>> 			continue;
>>=20
>> -		frob_text(&mod->core_layout, set_memory_ro);
>> -		frob_text(&mod->init_layout, set_memory_ro);
>> +		ret =3D frob_text(&mod->core_layout, set_memory_ro);
>> +		if (ret) {
>> +			mutex_unlock(&module_mutex);
>> +			return ret;
>> +		}
>> +		ret =3D frob_text(&mod->init_layout, set_memory_ro);
>> +		if (ret) {
>> +			mutex_unlock(&module_mutex);
>> +			return ret;
>> +		}
>> 	}
>> 	mutex_unlock(&module_mutex);
>> +	return 0;
>> }
>> #else /* !CONFIG_STRICT_MODULE_RWX */
>> -static void module_enable_nx(const struct module *mod) { }
>> +static int module_enable_nx(const struct module *mod) { return 0; }
>> #endif /*  CONFIG_STRICT_MODULE_RWX */
>> -static void module_enable_x(const struct module *mod)
>> +static int module_enable_x(const struct module *mod)
>> {
>> -	frob_text(&mod->core_layout, set_memory_x);
>> -	frob_text(&mod->init_layout, set_memory_x);
>> +	int ret;
>> +	ret =3D frob_text(&mod->core_layout, set_memory_x);
>> +	if (ret)
>> +		return ret;
>> +	ret =3D frob_text(&mod->init_layout, set_memory_x);
>> +	if (ret)
>> +		return ret;
>> +	return 0;
>> }
>> #else /* !CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
>> -static void module_enable_nx(const struct module *mod) { }
>> -static void module_enable_x(const struct module *mod) { }
>> +static int module_enable_nx(const struct module *mod) { return 0; }
>> +static int module_enable_x(const struct module *mod) { return 0; }
>> #endif /* CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
>>=20
>>=20
>> @@ -3534,7 +3600,11 @@ static noinline int do_init_module(struct =
module *mod)
>> 	/* Switch to core kallsyms now init is done: kallsyms may be =
walking! */
>> 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
>> #endif
>> -	module_enable_ro(mod, true);
>> +	ret =3D module_enable_ro(mod, true);
>> +	if (ret) {
>> +		mutex_unlock(&module_mutex);
>> +		goto fail_free_freeinit;
>> +	}
>> 	mod_tree_remove_init(mod);
>> 	module_arch_freeing_init(mod);
>> 	mod->init_layout.base =3D NULL;
>> @@ -3640,9 +3710,15 @@ static int complete_formation(struct module =
*mod, struct load_info *info)
>> 	/* This relies on module_mutex for list integrity. */
>> 	module_bug_finalize(info->hdr, info->sechdrs, mod);
>>=20
>> -	module_enable_ro(mod, false);
>> -	module_enable_nx(mod);
>> -	module_enable_x(mod);
>> +	err =3D module_enable_ro(mod, false);
>> +	if (err)
>> +		goto out;
>> +	err =3D module_enable_nx(mod);
>> +	if (err)
>> +		goto out;
>> +	err =3D module_enable_x(mod);
>> +	if (err)
>> +		goto out;
>>=20
>> 	/* Mark state as coming so strong_try_module_get() ignores us,
>> 	 * but kallsyms etc. can see us. */
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index f9821a3374e9..d4532bb65d1b 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -5814,8 +5814,13 @@ void ftrace_module_enable(struct module *mod)
>> 	 * text to read-only, as we now need to set it back to =
read-write
>> 	 * so that we can modify the text.
>> 	 */
>> -	if (ftrace_start_up)
>> -		ftrace_arch_code_modify_prepare();
>> +	if (ftrace_start_up) {
>> +		int ret =3D ftrace_arch_code_modify_prepare();
>> +		if (ret) {
>> +			FTRACE_WARN_ON(ret);
>> +			goto out_unlock;
>> +		}
>=20
> Can FTRACE_WARN_ON() be used in an "if" like WARN_ON? This could maybe
> look like:
>=20
> 	ret =3D ftrace_arch...
> 	if (FTRACE_WARN_ON(ret))
> 		goto out_unlock
>=20
> Though I not this doesn't result in an error getting passed up? i.e.
> ftrace_module_enable() is still "void". Does that matter here?
Thanks. I will fix it in v2.=20

>> +	}
>>=20
>> 	do_for_each_ftrace_rec(pg, rec) {
>> 		int cnt;
>> @@ -5854,8 +5859,10 @@ void ftrace_module_enable(struct module *mod)
>> 	} while_for_each_ftrace_rec();
>>=20
>>  out_loop:
>> -	if (ftrace_start_up)
>> -		ftrace_arch_code_modify_post_process();
>> +	if (ftrace_start_up) {
>> +		int ret =3D ftrace_arch_code_modify_post_process();
>> +		FTRACE_WARN_ON(ret);
>> +	}
>>=20
>>  out_unlock:
>> 	mutex_unlock(&ftrace_lock);
>> --=20
>> 2.17.1
>>=20
>=20
> Thanks,
Thanks for all detail suggestions!=20
> --=20
> Kees Cook


--Apple-Mail=_96CC2F9E-A2F9-4977-908B-8F533F03F8D0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><br =
class=3D""><div><blockquote type=3D"cite" class=3D""><div class=3D"">On =
Nov 19, 2019, at 11:07 AM, Kees Cook &lt;<a =
href=3D"mailto:keescook@chromium.org" =
class=3D"">keescook@chromium.org</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">On Tue, Nov 19, 2019 at =
09:51:49AM -0600, Tianlin Li wrote:</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D"">Right now several architectures allow =
their set_memory_*() family of<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">functions to =
fail, but callers may not be checking the return values. We<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">need to fix =
the callers and add the __must_check attribute. They also may<br =
class=3D"">not provide any level of atomicity, in the sense that the =
memory<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">protections may be left incomplete on failure. This issue =
likely has a few<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">steps on effects architectures[1]:<br =
class=3D""></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Awesome; thanks for working on this!</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">A few suggestions on this patch, =
which will help reviewers, below...</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D"">1)Have all callers of set_memory_*() =
helpers check the return value.<br class=3D"">2)Add __much_check to all =
set_memory_*() helpers so that new uses do not<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">ignore the =
return value.<br class=3D"">3)Add atomicity to the calls so that the =
memory protections aren't left in<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">a partial =
state.<br class=3D""></blockquote><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Maybe clarify to say something like "this series is step =
1=E2=80=9D?</span></div></blockquote><div>ok. Will add the =
clarification. Thanks!</div><blockquote type=3D"cite" class=3D""><div =
class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><blockquote type=3D"cite" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><br =
class=3D"">Ideally, the failure of set_memory_*() should be passed up =
the call stack,<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">and callers should examine the failure and deal with it. But =
currently,<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">some callers just have void return type.<br class=3D""><br =
class=3D"">We need to fix the callers to handle the return all the way =
to the top of<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">stack, and it will require a large series of patches to =
finish all the three<span class=3D"Apple-converted-space">&nbsp;</span><br=
 class=3D"">steps mentioned above. I start with kernel/module, and will =
move onto other<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">subsystems. I am not entirely sure about the failure modes =
for each caller.<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">So I would like to get some comments before I move forward. =
This single<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">patch is just for fixing the return value of set_memory_*() =
function in<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">kernel/module, and also the related callers. Any feedback =
would be greatly<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">appreciated.<br class=3D""><br class=3D"">[1]:<a =
href=3D"https://github.com/KSPP/linux/issues/7" =
class=3D"">https://github.com/KSPP/linux/issues/7</a><br class=3D""><br =
class=3D"">Signed-off-by: Tianlin Li &lt;<a =
href=3D"mailto:tli@digitalocean.com" =
class=3D"">tli@digitalocean.com</a>&gt;<br class=3D"">---<br =
class=3D"">arch/arm/kernel/ftrace.c &nbsp;&nbsp;| &nbsp;&nbsp;8 +-<br =
class=3D"">arch/arm64/kernel/ftrace.c | &nbsp;&nbsp;6 +-<br =
class=3D"">arch/nds32/kernel/ftrace.c | &nbsp;&nbsp;6 +-<br =
class=3D"">arch/x86/kernel/ftrace.c &nbsp;&nbsp;| &nbsp;13 ++-<br =
class=3D"">include/linux/module.h &nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;16 =
++--<br class=3D"">kernel/livepatch/core.c &nbsp;&nbsp;&nbsp;| &nbsp;15 =
+++-<br class=3D"">kernel/module.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 170 =
+++++++++++++++++++++++++++----------<br class=3D"">kernel/trace/ftrace.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;15 +++-<br class=3D"">8 files =
changed, 175 insertions(+), 74 deletions(-)<br class=3D""></blockquote><br=
 style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">- Can you break this patch into =
3 separate patches, by "subsystem":</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">- =
ftrace</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">- module</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">- livepatch =
(unless Jessica thinks maybe livepatch should go</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;">	</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D""><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;with =
module?)</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">- Please run =
patches through scripts/checkpatch.pl to catch common</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">&nbsp;coding style issues (e.g. =
blank line between variable declarations</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&nbsp;and function body).</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">- These changes look pretty straight forward, so I think it'd =
be fine</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">&nbsp;to drop =
the "RFC" tag and include<span =
class=3D"Apple-converted-space">&nbsp;</span></span><a =
href=3D"mailto:linux-kernel@vger.kernel.org" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px;" =
class=3D"">linux-kernel@vger.kernel.org</a><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D""><span class=3D"Apple-converted-space">&nbsp;</span>in =
the</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">&nbsp;Cc list =
for the v2. For lots of detail, see:</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&nbsp;</span><a =
href=3D"https://www.kernel.org/doc/html/latest/process/submitting-patches.=
html" =
class=3D"">https://www.kernel.org/doc/html/latest/process/submitting-patch=
es.html</a><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""></div></blockquote><div><br class=3D""></div><div>ok. =
I will fix them in v2. Thanks a lot!&nbsp;</div><blockquote type=3D"cite" =
class=3D""><div class=3D""><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">More below...</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br class=3D"">diff --git =
a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c<br class=3D"">index =
bda949fd84e8..7ea1338821d6 100644<br class=3D"">--- =
a/arch/arm/kernel/ftrace.c<br class=3D"">+++ =
b/arch/arm/kernel/ftrace.c<br class=3D"">@@ -59,13 +59,15 @@ static =
unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long =
addr)<br class=3D""><br class=3D"">int =
ftrace_arch_code_modify_prepare(void)<br class=3D"">{<br class=3D"">-<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_all_modules_text_rw();<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return set_all_modules_text_rw();<br class=3D"">}<br =
class=3D""><br class=3D"">int =
ftrace_arch_code_modify_post_process(void)<br class=3D"">{<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_all_modules_text_ro();<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>int =
ret;<br class=3D""></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Blank line here...</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
set_all_modules_text_ro();<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (ret)<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>/* Make sure any TLB misses during machine stop are =
cleared. */<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>flush_tlb_all();<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>return 0;<br class=3D""></blockquote><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Are callers of these ftrace functions checking return values =
too?</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""></div></blockquote><div>ftrace_arch_code_modify_prepare =
is called in ftrace_run_update_code and =
ftrace_module_enable.&nbsp;</div><div>ftrace_run_update_code is checking =
the return value of ftrace_arch_code_modify_prepare =
already.&nbsp;</div><div>ftrace_module_enable didn=E2=80=99t check. (I =
modifies this function in this patch to check the return value of =
ftrace_arch_code_modify_prepare ).&nbsp;</div><div>Same for =
ftrace_arch_code_modify_post_process.&nbsp;</div><div><br =
class=3D""></div><blockquote type=3D"cite" class=3D""><div =
class=3D""><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D"">diff =
--git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c<br =
class=3D"">index 171773257974..97a89c38f6b9 100644<br class=3D"">--- =
a/arch/arm64/kernel/ftrace.c<br class=3D"">+++ =
b/arch/arm64/kernel/ftrace.c<br class=3D"">@@ -115,9 +115,11 @@ int =
ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>}<br class=3D""><br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>/* point the trampoline to our =
ftrace entry point */<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>module_disable_ro(mod);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (module_disable_ro(mod))<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
-EINVAL;<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>*dst =3D trampoline;<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_enable_ro(mod, true);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(module_enable_ro(mod, true))<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
-EINVAL;<br class=3D""><br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>/*<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* Ensure updated trampoline =
is visible to instruction<br class=3D"">diff --git =
a/arch/nds32/kernel/ftrace.c b/arch/nds32/kernel/ftrace.c<br =
class=3D"">index fd2a54b8cd57..e9e63e703a3e 100644<br class=3D"">--- =
a/arch/nds32/kernel/ftrace.c<br class=3D"">+++ =
b/arch/nds32/kernel/ftrace.c<br class=3D"">@@ -91,14 +91,12 @@ int =
__init ftrace_dyn_arch_init(void)<br class=3D""><br class=3D"">int =
ftrace_arch_code_modify_prepare(void)<br class=3D"">{<br class=3D"">-<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_all_modules_text_rw();<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return set_all_modules_text_rw();<br class=3D"">}<br =
class=3D""><br class=3D"">int =
ftrace_arch_code_modify_post_process(void)<br class=3D"">{<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_all_modules_text_ro();<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return set_all_modules_text_ro();<br class=3D"">}<br =
class=3D""><br class=3D"">static unsigned long gen_sethi_insn(unsigned =
long addr)<br class=3D"">diff --git a/arch/x86/kernel/ftrace.c =
b/arch/x86/kernel/ftrace.c<br class=3D"">index =
024c3053dbba..7fdee06e2a76 100644<br class=3D"">--- =
a/arch/x86/kernel/ftrace.c<br class=3D"">+++ =
b/arch/x86/kernel/ftrace.c<br class=3D"">@@ -42,19 +42,26 @@ int =
ftrace_arch_code_modify_prepare(void)<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* and live kernel patching =
from changing the text permissions while<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* ftrace has it set to =
"read/write".<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>*/<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>int =
ret;<br class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>mutex_lock(&amp;text_mutex);<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_kernel_text_rw();<br class=3D"">-<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span>set_all_modules_text_rw();<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>ret =3D set_all_modules_text_rw();<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if (ret) =
{<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>set_kernel_text_ro();<br class=3D""></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Is the set_kernel_text_ro() here =
is an atomicity fix? Also, won't a future</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">patch need to check the result of that function call? (i.e. =
should it</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">be left out =
of this series and should atomicity fixes happen inside the</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">set_memory_*() functions? Can =
they happen there?)</span></div></blockquote><div>set_kernel_text_tro() =
here was not for an atomicity fix in step 3, it was just for reverting =
the status&nbsp;</div><div>in ftrace_arch_code_modify_prepare, because =
set_kernel_text_rw() is called.&nbsp;</div><div>Thanks for pointing it =
out. &nbsp;I will check it.&nbsp;</div></div><div><blockquote =
type=3D"cite" class=3D""><div class=3D""><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>mutex_unlock(&amp;text_mutex);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>}<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">}<br class=3D""><br class=3D"">int =
ftrace_arch_code_modify_post_process(void)<br =
class=3D"">&nbsp;&nbsp;&nbsp;&nbsp;__releases(&amp;text_mutex)<br =
class=3D"">{<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>set_all_modules_text_ro();<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>int ret;<br class=3D""></blockquote><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">blank line needed...</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
set_all_modules_text_ro();<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>set_kernel_text_ro();<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;text_mutex);<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">}<br class=3D""><br =
class=3D"">union ftrace_code_union {<br class=3D"">diff --git =
a/include/linux/module.h b/include/linux/module.h<br class=3D"">index =
1455812dd325..e6c7f3b719a3 100644<br class=3D"">--- =
a/include/linux/module.h<br class=3D"">+++ b/include/linux/module.h<br =
class=3D"">@@ -847,15 +847,15 @@ extern int module_sysfs_initialized;<br =
class=3D"">#define __MODULE_STRING(x) __stringify(x)<br class=3D""><br =
class=3D"">#ifdef CONFIG_STRICT_MODULE_RWX<br class=3D"">-extern void =
set_all_modules_text_rw(void);<br class=3D"">-extern void =
set_all_modules_text_ro(void);<br class=3D"">-extern void =
module_enable_ro(const struct module *mod, bool after_init);<br =
class=3D"">-extern void module_disable_ro(const struct module *mod);<br =
class=3D"">+extern int set_all_modules_text_rw(void);<br =
class=3D"">+extern int set_all_modules_text_ro(void);<br =
class=3D"">+extern int module_enable_ro(const struct module *mod, bool =
after_init);<br class=3D"">+extern int module_disable_ro(const struct =
module *mod);<br class=3D"">#else<br class=3D"">-static inline void =
set_all_modules_text_rw(void) { }<br class=3D"">-static inline void =
set_all_modules_text_ro(void) { }<br class=3D"">-static inline void =
module_enable_ro(const struct module *mod, bool after_init) { }<br =
class=3D"">-static inline void module_disable_ro(const struct module =
*mod) { }<br class=3D"">+static inline int set_all_modules_text_rw(void) =
{ return 0; }<br class=3D"">+static inline int =
set_all_modules_text_ro(void) { return 0; }<br class=3D"">+static inline =
int module_enable_ro(const struct module *mod, bool after_init) { return =
0; }<br class=3D""></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Please wrap this line (yes, the old one wasn't...)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" =
class=3D""><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D"">+static=
 inline int module_disable_ro(const struct module *mod) { return 0; }<br =
class=3D"">#endif<br class=3D""><br class=3D"">#ifdef =
CONFIG_GENERIC_BUG<br class=3D"">diff --git a/kernel/livepatch/core.c =
b/kernel/livepatch/core.c<br class=3D"">index c4ce08f43bd6..39bfc0685854 =
100644<br class=3D"">--- a/kernel/livepatch/core.c<br class=3D"">+++ =
b/kernel/livepatch/core.c<br class=3D"">@@ -721,16 +721,25 @@ static int =
klp_init_object_loaded(struct klp_patch *patch,<br class=3D""><br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mutex_lock(&amp;text_mutex);<br class=3D""><br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_disable_ro(patch-&gt;mod);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
module_disable_ro(patch-&gt;mod);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if (ret) =
{<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>mutex_unlock(&amp;text_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
klp_write_object_relocations(patch-&gt;mod, obj);<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if (ret) =
{<br class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>module_enable_ro(patch-&gt;mod, true);<br class=3D"">+<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(module_enable_ro(patch-&gt;mod, true));<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>pr_err("module_enable_ro failed.\n");<br =
class=3D""></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Why the pr_err() here and not in other failure cases? (Also, =
should it</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">instead be a =
WARN_ONCE() inside the set_memory_*() functions instead?)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" =
class=3D""></div></blockquote>Because module_enable_ro() is called in =
the checking of another return value. I can not return the value, so I =
print the error.&nbsp;</div><div>Similar to the previous question, =
should it be fixed by atomicity patches =
later?&nbsp;</div><div><blockquote type=3D"cite" class=3D""><div =
class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><blockquote type=3D"cite" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;text_mutex);<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br class=3D""><br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>arch_klp_init_object_loaded(patch, obj);<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_enable_ro(patch-&gt;mod, true);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
module_enable_ro(patch-&gt;mod, true);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if (ret) =
{<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>mutex_unlock(&amp;text_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br class=3D""><br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;text_mutex);<br class=3D""><br class=3D"">diff =
--git a/kernel/module.c b/kernel/module.c<br class=3D"">index =
9ee93421269c..87125b5e315c 100644<br class=3D"">--- a/kernel/module.c<br =
class=3D"">+++ b/kernel/module.c<br class=3D"">@@ -1900,111 +1900,162 @@ =
static void mod_sysfs_teardown(struct module *mod)<br =
class=3D"">&nbsp;*<br class=3D"">&nbsp;* These values are always =
page-aligned (as is base)<br class=3D"">&nbsp;*/<br class=3D"">-static =
void frob_text(const struct module_layout *layout,<br class=3D"">+static =
int frob_text(const struct module_layout *layout,<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;int (*set_memory)(unsigned long start, int num_pages))<br class=3D"">{<br=
 class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;base &amp; (PAGE_SIZE-1));<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;text_size &amp; =
(PAGE_SIZE-1));<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>set_memory((unsigned =
long)layout-&gt;base,<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return set_memory((unsigned =
long)layout-&gt;base,<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;layout-&gt;text_s=
ize &gt;&gt; PAGE_SHIFT);<br class=3D"">}<br class=3D""><br =
class=3D"">#ifdef CONFIG_STRICT_MODULE_RWX<br class=3D"">-static void =
frob_rodata(const struct module_layout *layout,<br class=3D"">+static =
int frob_rodata(const struct module_layout *layout,<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>int =
(*set_memory)(unsigned long start, int num_pages))<br class=3D"">{<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;base &amp; (PAGE_SIZE-1));<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;text_size &amp; =
(PAGE_SIZE-1));<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>BUG_ON((unsigned =
long)layout-&gt;ro_size &amp; (PAGE_SIZE-1));<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_memory((unsigned long)layout-&gt;base + =
layout-&gt;text_size,<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return set_memory((unsigned =
long)layout-&gt;base + layout-&gt;text_size,<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;(layout-&gt;ro_si=
ze - layout-&gt;text_size) &gt;&gt; PAGE_SHIFT);<br class=3D"">}<br =
class=3D""><br class=3D"">-static void frob_ro_after_init(const struct =
module_layout *layout,<br class=3D"">+static int =
frob_ro_after_init(const struct module_layout *layout,<br class=3D""><span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>int =
(*set_memory)(unsigned long start, int num_pages))<br class=3D"">{<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;base &amp; (PAGE_SIZE-1));<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;ro_size &amp; (PAGE_SIZE-1));<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;ro_after_init_size &amp; =
(PAGE_SIZE-1));<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>set_memory((unsigned =
long)layout-&gt;base + layout-&gt;ro_size,<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
set_memory((unsigned long)layout-&gt;base + layout-&gt;ro_size,<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;(layout-&gt;ro_af=
ter_init_size - layout-&gt;ro_size) &gt;&gt; PAGE_SHIFT);<br =
class=3D"">}<br class=3D""><br class=3D"">-static void =
frob_writable_data(const struct module_layout *layout,<br =
class=3D"">+static int frob_writable_data(const struct module_layout =
*layout,<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;int (*set_memory)(unsigned long start, int num_pages))<br =
class=3D"">{<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>BUG_ON((unsigned =
long)layout-&gt;base &amp; (PAGE_SIZE-1));<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BUG_ON((unsigned long)layout-&gt;ro_after_init_size &amp; =
(PAGE_SIZE-1));<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>BUG_ON((unsigned =
long)layout-&gt;size &amp; (PAGE_SIZE-1));<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_memory((unsigned long)layout-&gt;base + =
layout-&gt;ro_after_init_size,<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
set_memory((unsigned long)layout-&gt;base + =
layout-&gt;ro_after_init_size,<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;(layout-&gt;size =
- layout-&gt;ro_after_init_size) &gt;&gt; PAGE_SHIFT);<br class=3D"">}<br =
class=3D""><br class=3D"">/* livepatching wants to disable read-only so =
it can frob module. */<br class=3D"">-void module_disable_ro(const =
struct module *mod)<br class=3D"">+int module_disable_ro(const struct =
module *mod)<br class=3D"">{<br class=3D"">+<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span>int ret;<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(!rodata_enabled)<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D""><br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;core_layout, set_memory_rw);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_rodata(&amp;mod-&gt;core_layout, set_memory_rw);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_ro_after_init(&amp;mod-&gt;core_layout, set_memory_rw);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;init_layout, set_memory_rw);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_rodata(&amp;mod-&gt;init_layout, set_memory_rw);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>ret =3D frob_text(&amp;mod-&gt;core_layout, set_memory_rw);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
frob_rodata(&amp;mod-&gt;core_layout, set_memory_rw);<br class=3D"">+<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_ro_after_init(&amp;mod-&gt;core_layout, set_memory_rw);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
frob_text(&amp;mod-&gt;init_layout, set_memory_rw);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_rodata(&amp;mod-&gt;init_layout, set_memory_rw);<br class=3D"">+<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">}<br class=3D""><br class=3D"">-void =
module_enable_ro(const struct module *mod, bool after_init)<br =
class=3D"">+int module_enable_ro(const struct module *mod, bool =
after_init)<br class=3D"">{<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>int ret;<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(!rodata_enabled)<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D""><br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>set_vm_flush_reset_perms(mod-&gt;core_layout.base);<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_vm_flush_reset_perms(mod-&gt;init_layout.base);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>ret =3D frob_text(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D""><br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_rodata(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;init_layout, set_memory_ro);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_rodata(&amp;mod-&gt;init_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>ret =3D frob_rodata(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
frob_text(&amp;mod-&gt;init_layout, set_memory_ro);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_rodata(&amp;mod-&gt;init_layout, set_memory_ro);<br class=3D"">+<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D""><br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(after_init)<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>frob_ro_after_init(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (after_init) {<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_ro_after_init(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>}<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>return 0;<br class=3D"">}<br class=3D""><br class=3D"">-static =
void module_enable_nx(const struct module *mod)<br class=3D"">+static =
int module_enable_nx(const struct module *mod)<br class=3D"">{<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_rodata(&amp;mod-&gt;core_layout, set_memory_nx);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_ro_after_init(&amp;mod-&gt;core_layout, set_memory_nx);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_writable_data(&amp;mod-&gt;core_layout, set_memory_nx);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_rodata(&amp;mod-&gt;init_layout, set_memory_nx);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_writable_data(&amp;mod-&gt;init_layout, set_memory_nx);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>int ret;<br class=3D"">+<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
frob_rodata(&amp;mod-&gt;core_layout, set_memory_nx);<br class=3D"">+<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_ro_after_init(&amp;mod-&gt;core_layout, set_memory_nx);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
frob_writable_data(&amp;mod-&gt;core_layout, set_memory_nx);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
frob_rodata(&amp;mod-&gt;init_layout, set_memory_nx);<br class=3D"">+<span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_writable_data(&amp;mod-&gt;init_layout, set_memory_nx);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return ret;<br class=3D"">+<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>return 0;<br class=3D"">}<br class=3D""><br class=3D"">/* Iterate =
through all modules and set each module's text as RW */<br =
class=3D"">-void set_all_modules_text_rw(void)<br class=3D"">+int =
set_all_modules_text_rw(void)<br class=3D"">{<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>struct =
module *mod;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>int ret;<br class=3D""><br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (!rodata_enabled)<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D""><br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>mutex_lock(&amp;module_mutex);<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>list_for_each_entry_rcu(mod, &amp;modules, list) {<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (mod-&gt;state =3D=3D MODULE_STATE_UNFORMED)<br class=3D""><span=
 class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>continue;<br class=3D""><br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;core_layout, set_memory_rw);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;init_layout, set_memory_rw);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>ret =3D frob_text(&amp;mod-&gt;core_layout, set_memory_rw);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret) {<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;module_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_text(&amp;mod-&gt;init_layout, set_memory_rw);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if (ret) =
{<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>mutex_unlock(&amp;module_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br class=3D""></blockquote><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">This pattern feels like it might be better with a "goto out" =
style:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">mutex_lock...</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" =
class=3D"">list_for_each... {</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;">	</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">ret =3D =
frob_...</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">if =
(ret)</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;">	</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">goto =
out;</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">ret =3D =
frob_...</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">if =
(ret)</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;">	</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">goto =
out;</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">}</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">ret =3D 0;</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">out:</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" =
class=3D"">mutex_unlock...</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">return =
ret;</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""></div></blockquote><div><br class=3D""></div>Thanks! =
Will fix it in v2.&nbsp;<br class=3D""><blockquote type=3D"cite" =
class=3D""><div class=3D""><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>}<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;module_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">}<br class=3D""><br class=3D"">/* Iterate through all =
modules and set each module's text as RO */<br class=3D"">-void =
set_all_modules_text_ro(void)<br class=3D"">+int =
set_all_modules_text_ro(void)<br class=3D"">{<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>struct =
module *mod;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>int ret;<br class=3D""><br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (!rodata_enabled)<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return;<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D""><br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>mutex_lock(&amp;module_mutex);<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>list_for_each_entry_rcu(mod, &amp;modules, list) {<br class=3D"">@@=
 -2017,22 +2068,37 @@ void set_all_modules_text_ro(void)<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mod-&gt;state =3D=3D MODULE_STATE_GOING)<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>continue;<br class=3D""><br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;init_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>ret =3D frob_text(&amp;mod-&gt;core_layout, set_memory_ro);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ret) {<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;module_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_text(&amp;mod-&gt;init_layout, set_memory_ro);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if (ret) =
{<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>mutex_unlock(&amp;module_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
ret;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>}<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;module_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
0;<br class=3D"">}<br class=3D"">#else /* !CONFIG_STRICT_MODULE_RWX =
*/<br class=3D"">-static void module_enable_nx(const struct module *mod) =
{ }<br class=3D"">+static int module_enable_nx(const struct module *mod) =
{ return 0; }<br class=3D"">#endif /* &nbsp;CONFIG_STRICT_MODULE_RWX =
*/<br class=3D"">-static void module_enable_x(const struct module =
*mod)<br class=3D"">+static int module_enable_x(const struct module =
*mod)<br class=3D"">{<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;core_layout, set_memory_x);<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>frob_text(&amp;mod-&gt;init_layout, set_memory_x);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>int ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_text(&amp;mod-&gt;core_layout, set_memory_x);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D =
frob_text(&amp;mod-&gt;init_layout, set_memory_x);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ret)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return ret;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return 0;<br class=3D"">}<br =
class=3D"">#else /* !CONFIG_ARCH_HAS_STRICT_MODULE_RWX */<br =
class=3D"">-static void module_enable_nx(const struct module *mod) { =
}<br class=3D"">-static void module_enable_x(const struct module *mod) { =
}<br class=3D"">+static int module_enable_nx(const struct module *mod) { =
return 0; }<br class=3D"">+static int module_enable_x(const struct =
module *mod) { return 0; }<br class=3D"">#endif /* =
CONFIG_ARCH_HAS_STRICT_MODULE_RWX */<br class=3D""><br class=3D""><br =
class=3D"">@@ -3534,7 +3600,11 @@ static noinline int =
do_init_module(struct module *mod)<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>/* Switch =
to core kallsyms now init is done: kallsyms may be walking! */<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>rcu_assign_pointer(mod-&gt;kallsyms, =
&amp;mod-&gt;core_kallsyms);<br class=3D"">#endif<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_enable_ro(mod, true);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
module_enable_ro(mod, true);<br class=3D"">+<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span>if (ret) {<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;module_mutex);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>goto =
fail_free_freeinit;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>}<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mod_tree_remove_init(mod);<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_arch_freeing_init(mod);<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mod-&gt;init_layout.base =3D NULL;<br class=3D"">@@ -3640,9 =
+3710,15 @@ static int complete_formation(struct module *mod, struct =
load_info *info)<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>/* This relies on module_mutex =
for list integrity. */<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>module_bug_finalize(info-&gt;hdr, =
info-&gt;sechdrs, mod);<br class=3D""><br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_enable_ro(mod, false);<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_enable_nx(mod);<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>module_enable_x(mod);<br class=3D"">+<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span>err =3D module_enable_ro(mod, =
false);<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (err)<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>goto =
out;<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>err =3D module_enable_nx(mod);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(err)<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>goto out;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>err =3D module_enable_x(mod);<br =
class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (err)<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>goto out;<br class=3D""><br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>/* Mark state as coming so strong_try_module_get() ignores us,<br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-converted-space">&nbsp;</span>* but kallsyms =
etc. can see us. */<br class=3D"">diff --git a/kernel/trace/ftrace.c =
b/kernel/trace/ftrace.c<br class=3D"">index f9821a3374e9..d4532bb65d1b =
100644<br class=3D"">--- a/kernel/trace/ftrace.c<br class=3D"">+++ =
b/kernel/trace/ftrace.c<br class=3D"">@@ -5814,8 +5814,13 @@ void =
ftrace_module_enable(struct module *mod)<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* text to read-only, as we =
now need to set it back to read-write<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* so that we can modify the =
text.<br class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-converted-space">&nbsp;</span>*/<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (ftrace_start_up)<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>ftrace_arch_code_modify_prepare();<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ftrace_start_up) {<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>int ret =3D =
ftrace_arch_code_modify_prepare();<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if (ret) =
{<br class=3D"">+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>FTRACE_WARN_ON(ret);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>goto =
out_unlock;<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>}<br class=3D""></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Can FTRACE_WARN_ON() be used in =
an "if" like WARN_ON? This could maybe</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">look like:</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">ret =3D =
ftrace_arch...</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">if =
(FTRACE_WARN_ON(ret))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;">	</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">goto =
out_unlock</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">Though I not =
this doesn't result in an error getting passed up? i.e.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">ftrace_module_enable() is still =
"void". Does that matter here?</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""></div></blockquote><div>Thanks. I =
will fix it in v2.&nbsp;</div><div><br class=3D""></div><blockquote =
type=3D"cite" class=3D""><div class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>}<br class=3D""><br =
class=3D""><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>do_for_each_ftrace_rec(pg, rec) {<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>int =
cnt;<br class=3D"">@@ -5854,8 +5859,10 @@ void =
ftrace_module_enable(struct module *mod)<br class=3D""><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>} =
while_for_each_ftrace_rec();<br class=3D""><br =
class=3D"">&nbsp;out_loop:<br class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (ftrace_start_up)<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>ftrace_arch_code_modify_post_process();<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(ftrace_start_up) {<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>int ret =3D =
ftrace_arch_code_modify_post_process();<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>FTRACE_WARN_ON(ret);<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>}<br class=3D""><br =
class=3D"">&nbsp;out_unlock:<br class=3D""><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>mutex_unlock(&amp;ftrace_lock);<br class=3D"">--<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">2.17.1<br =
class=3D""><br class=3D""></blockquote><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Thanks,</span></div></blockquote>Thanks for all detail =
suggestions!&nbsp;<br class=3D""><blockquote type=3D"cite" class=3D""><div=
 class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">--<span =
class=3D"Apple-converted-space">&nbsp;</span></span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Kees =
Cook</span></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_96CC2F9E-A2F9-4977-908B-8F533F03F8D0--
