Return-Path: <SRS0=KPfg=AU=lists.openwall.com=kernel-hardening-return-19274-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3261C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 17:26:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EDFE520767
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 17:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDFE520767
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19274-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11488 invoked by uid 550); 9 Jul 2020 17:26:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11453 invoked from network); 9 Jul 2020 17:26:47 -0000
X-Gm-Message-State: AOAM531SgaAFozEL0fRLPtuPjfD/HQLLBBhB13vmPPbpMgAEI2qxR7nH
	sTSMqI4rcr4+0xkrRoCe0ukq7BXlb7bHhvJes3w=
X-Google-Smtp-Source: ABdhPJxrBo0AwUBiMw2v4TVCTLmtL0EMGqThmAS9J2fIdN9aQHe1QjAu6oSNR/5pXdXtSVlu3fBviu/RfylxDKEg8NM=
X-Received: by 2002:a37:b484:: with SMTP id d126mr64230494qkf.394.1594315594655;
 Thu, 09 Jul 2020 10:26:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200707180955.53024-1-mic@digikod.net> <20200707180955.53024-9-mic@digikod.net>
 <CAK8P3a0FkoxFtcQJ2jSqyLbDCOp3R8-1JoY8CWAgbSZ9hH9wdQ@mail.gmail.com>
 <7f407b67-d470-25fd-1287-f4f55f18e74a@digikod.net> <CAK8P3a1ehWZErD2a0iBqn37s-LTAtW0AbV_gt32iX3cQkXbpOQ@mail.gmail.com>
 <ec79f6ad-1c11-d69f-724b-622baa28f19f@digikod.net>
In-Reply-To: <ec79f6ad-1c11-d69f-724b-622baa28f19f@digikod.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 9 Jul 2020 19:26:18 +0200
X-Gmail-Original-Message-ID: <CAK8P3a34X1qfDhn8u3nR+aQA_g+V2i35L0oTnvhNAs83YJPB_w@mail.gmail.com>
Message-ID: <CAK8P3a34X1qfDhn8u3nR+aQA_g+V2i35L0oTnvhNAs83YJPB_w@mail.gmail.com>
Subject: Re: [PATCH v19 08/12] landlock: Add syscall implementation
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@amacapital.net>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, 
	Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gzNLvTfzMpln8ORXQ5pfdFjnGTvK1UIjMhBhLbUyrwoMxIl8gfl
 nJCGWiSYH8TI1I8Yg+U7rlgrW3D5dsPyFul4Fi/CxRBOf9thGPcHmyrctBKe1L2S7nK8jCM
 Ysl3Mq4Rguw1aLHCn8axRqJvoecCo0NKsQZJ+8yPTI0Gj9KVqFB2meheg1sy+YGsIgaUS/6
 6gCLZrXvjzOS+OiyXOLWQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ilQUQtxU0G8=:PyiW0irWfCcWnGsmTL/S6K
 x8s1sMkp5AYjSgBOCb5155AIBHT/Y5ybw4FX9mUzQMT0a/plGA3cbJICb9ErBaUkMG1A/9IIp
 J+MXZff09cMHkh/8U/XdOnAmH6j8K5wrOs6KnFdrMkKuDSjhhL0xVvL6cA+QN04o54haAqpu2
 670Rov8ReA1ZPYzqJJrNkL/hqecA3OZp1GKnsPmkqljXos5iFgYrnvYJN34qGcdu2+NYCCs6F
 q4Cp+Fbk8qB4VDFnmm1scQjrns6/kF9TJvRpQ5kx6KR2W3uRoSmG92EFo8FZ/ufHZFCnInv08
 mNaCqZmbgQVc9koLyiGOppqcFpShmdve424Gg8C9UqVWvjmgTY60zL6XHVqL76Os/WuOJ5zkP
 NgcA6lRrsu02jssCSQDLS5gTlEAhf3iSrEVNNacT3s000PLR9rvWmlhP03Ai645KwPjAq+29/
 oCHBfa7qYVe7gexF61MvdMhPHax3XlnIVg9FKBqtaPpcrYvaR0ErRHvW4Isx3BdI1wvyRieGG
 4vYOki/R1BZVvkOQtqsdbmVZx0BNAq4H+zSVAMIwUwJl1oHPRBbc1ZdpMb3tNNKe0vzC8XKrR
 iZl3fUuy5822cvthMuqa1xTbbUxy5iBVSd0DEKV2uOqvQrkxL0MBvI3yK5uYAg10bM+Nfw5v8
 q0DJrPv2i1njLXaVgYhA8V5ol0LyVTOQprjHzW7b9mCsm3vUmlDVFbU72wyBuJob56HtqHEVL
 MC8dKdEtlXupy1tW1Qf9bOtblGIaUFmjwi4ZOEf0cfwl0n46TVg8PjwPY3TlDXseY5iVKceEm
 XD2BSSE2ZLZSX+y1hIN4LV6koq+i5kWZTcl/9hPGPSKTJ0iyKv6gXD3tAXa2ZLRzDRStv4M51
 yxU9fzxikAsZjfCbJtQB4DWng1J/a96hPm94GzkufUXqy4y6Nz6WUIZ6fbL0xuU2+FE/gpelv
 P18NuEebmFBQiFcwz4Pu+c+WGuY372aoz0urq+iF5WyO6XD/glxwj

On Wed, Jul 8, 2020 at 7:50 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> w=
rote:
> On 08/07/2020 15:49, Arnd Bergmann wrote:
> > On Wed, Jul 8, 2020 at 3:04 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
> >> On 08/07/2020 10:57, Arnd Bergmann wrote:
> >>> On Tue, Jul 7, 2020 at 8:10 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.=
net> wrote:
> >>>
> >>> It looks like all you need here today is a single argument bit, plus
> >>> possibly some room for extensibility. I would suggest removing all
> >>> the extra bits and using a syscall like
> >>>
> >>> SYSCALL_DEFINE1(landlock_create_ruleset, u32, flags);
> >>>
> >>> I don't really see how this needs any variable-length arguments,
> >>> it really doesn't do much.
> >>
> >> We need the attr_ptr/attr_size pattern because the number of ruleset
> >> properties will increase (e.g. network access mask).
> >
> > But how many bits do you think you will *actually* need in total that
> > this needs to be a two-dimensional set of flags? At the moment you
> > only have a single bit that you interpret.
>
> I think there is a misunderstanding. For this syscall I wasn't talking
> about the "options" field but about the "handled_access_fs" field which
> has 14 bits dedicated to control access to the file system:
> https://landlock.io/linux-doc/landlock-v19/security/landlock/user.html#fi=
lesystem-flags

Ok, got it. I didn't read far enough there.

> The idea is to add other handled_access_* fields for other kernel object
> types (e.g. network, process, etc.).
>
> The "options" field is fine as a raw __u32 syscall argument.

I'd still like to avoid having it variable-length and structured though.
How about having a __u32 "options" flag, plus an indirect argument
with 32 fixed-length (all 32 bit or all 64 bit) flag words, each of which
corresponds to one of the option bits?

It's still fairly complex that way, but not as much as the version
you have right now that can be extended in multiple dimensions.

This could possibly also help avoid the need for the get_features
syscall: If user space just passes the bitmap of all the access flags
it wants to use in a fixed-size structure, the kernel can update the
bits to mask out the ones it does not understand and write back
that bitmap as the result of create_ruleset().

> >>> To be on the safe side, you might split up the flags into either the
> >>> upper/lower 16 bits or two u32 arguments, to allow both compatible
> >>> (ignored by older kernels if flag is set) and incompatible (return er=
ror
> >>> when an unknown flag is set) bits.
> >>
> >> This may be a good idea in general, but in the case of Landlock, becau=
se
> >> this kind of (discretionary) sandboxing should be a best-effort securi=
ty
> >> feature, we should avoid incompatible behavior. In practice, every
> >> unknown bit returns an error because userland can probe for available
> >> bits thanks to the get_features command. This kind of (in)compatibilit=
y
> >> can then be handled by userland.
> >
> > If there are not going to be incompatible extensions, then just ignore
> > all unknown bits and never return an error but get rid of the user
> > space probing that just complicates the interface.
>
> There was multiple discussions about ABI compatibility, especially
> inspired by open(2) vs. openat2(2), and ignoring flags seems to be a bad
> idea. In the "sandboxer" example, we first probe the supported features
> and then mask unknown bits (i.e. access rights) at run time in userland.
> This strategy is quite straightforward, backward compatible and
> future-proof.

For behavior changing flags, I agree they should be seen as
incompatible flags (i.e. return an error if an unknown bit is set).

However, for the flags you pass in in an allowlist, treating them
as compatible (i.e. ignore any unknown flags, allowing everything
you are not forbidding already) seems completely reasonable
to me. Do you foresee user space doing anything other than masking
out the bits that the kernel doesn't know about? If not, then doing
it in the  kernel should always be simpler.

> >> I suggest this syscall signature:
> >> SYSCALL_DEFINE3(landlock_create_ruleset, __u32, options, const struct
> >> landlock_attr_ruleset __user *, ruleset_ptr, size_t, ruleset_size);
> >
> > The other problem here is that indirect variable-size structured argume=
nts
> > are a pain to instrument with things like strace or seccomp, so you
> > should first try to use a fixed argument list, and fall back to a fixed
> > structure if that fails.
>
> I agree that it is not perfect with the current tools but this kind of
> extensible structs are becoming common and well defined (e.g. openat2).
> Moreover there is some work going on for seccomp to support "extensible
> argument" syscalls: https://lwn.net/Articles/822256/

openat2() is already more complex than we'd ideally want, I think we
should try hard to make new syscalls simpler than that, following the
rule that any interface should be as simple as possible, but no simpler.

> >>>> +static int syscall_add_rule_path_beneath(const void __user *const a=
ttr_ptr,
> >>>> +               const size_t attr_size)
> >>>> +{
> >>>> +       struct landlock_attr_path_beneath attr_path_beneath;
> >>>> +       struct path path;
> >>>> +       struct landlock_ruleset *ruleset;
> >>>> +       int err;
> >>>
> >>> Similarly, it looks like this wants to be
> >>>
> >>> SYSCALL_DEFINE3(landlock_add_rule_path_beneath, int, ruleset, int,
> >>> path, __u32, flags)
> >>>
> >>> I don't see any need to extend this in a way that wouldn't already
> >>> be served better by adding another system call. You might argue
> >>> that 'flags' and 'allowed_access' could be separate, with the latter
> >>> being an indirect in/out argument here, like
> >>>
> >>> SYSCALL_DEFINE4(landlock_add_rule_path_beneath, int, ruleset, int, pa=
th,
> >>>                            __u64 *, allowed_acces, __u32, flags)
> >>
> >> To avoid adding a new syscall for each new rule type (e.g. path_beneat=
h,
> >> path_range, net_ipv4_range, etc.), I think it would be better to keep
> >> the attr_ptr/attr_size pattern and to explicitely set a dedicated opti=
on
> >> flag to specify the attr type.
> >>
> >> This would look like this:
> >> SYSCALL_DEFINE4(landlock_add_rule, __u32, options, int, ruleset, const
> >> void __user *, rule_ptr, size_t, rule_size);
> >>
> >> The rule_ptr could then point to multiple types like struct
> >> landlock_attr_path_beneath (without the current ruleset_fd field).
> >
> > This again introduces variable-sized structured data. How many differen=
t
> > kinds of rule types do you think there will be (most likely, and maybe =
an
> > upper bound)?
>
> I don't know how many rule types will come, but right now I think it may
> be less than 10.

Ok,

> > Could (some of) these be generalized to use the same data structure?
>
> I don't think so, file path and network addresses are an example of very
> different types.

Clearly the target object is something different, but maybe there is
enough commonality to still make them fit into a more regular form.

For the file system case, you have an identify for an object
(the file descriptor) and the  '__u64 allowed_access'. I would
expect that the 'allowed_access' concept is generic enough that
you can make it a direct argument (32 bit register arg, or pointer
to a __u64). Do you expect others to need something besides
an object identifier and a permission bitmask? Maybe it could
be something like

 SYSCALL_DEFINE4(landlock_add_rule, int, ruleset, __u32, options,
                       const void __user *, object, const __u64 __user
*, allowed_access,
                       __u32, flags);

with a fixed-length 'object' identifier type (file descriptor,
sockaddr_storage, ...) for each option.

    Arnd
