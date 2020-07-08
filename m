Return-Path: <SRS0=OF4d=AT=lists.openwall.com=kernel-hardening-return-19257-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD245C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 13:50:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 08D792067D
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 13:50:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08D792067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19257-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1862 invoked by uid 550); 8 Jul 2020 13:50:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1827 invoked from network); 8 Jul 2020 13:50:26 -0000
X-Gm-Message-State: AOAM530Q7w7aNV9/GJlKH+zgzmNIxEoMg02QMmWiqKHx0ier67Pn0lH0
	eedRpIbClBIv63jFdbd2jTSPMmzKdG2xUKH3Y6Q=
X-Google-Smtp-Source: ABdhPJzGbqSLDVa+22V+OxqUS2NDeQMLg4lKFCfmasSmlQFshduHvuFJ4EYxw9p5RNP/z2hlcFkstPMlyhdckAfJkBA=
X-Received: by 2002:ac8:7587:: with SMTP id s7mr60215048qtq.304.1594216213827;
 Wed, 08 Jul 2020 06:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200707180955.53024-1-mic@digikod.net> <20200707180955.53024-9-mic@digikod.net>
 <CAK8P3a0FkoxFtcQJ2jSqyLbDCOp3R8-1JoY8CWAgbSZ9hH9wdQ@mail.gmail.com> <7f407b67-d470-25fd-1287-f4f55f18e74a@digikod.net>
In-Reply-To: <7f407b67-d470-25fd-1287-f4f55f18e74a@digikod.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 8 Jul 2020 15:49:57 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1ehWZErD2a0iBqn37s-LTAtW0AbV_gt32iX3cQkXbpOQ@mail.gmail.com>
Message-ID: <CAK8P3a1ehWZErD2a0iBqn37s-LTAtW0AbV_gt32iX3cQkXbpOQ@mail.gmail.com>
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
X-Provags-ID: V03:K1:/TR6+kWa1Nf1hqJbcR2TWgtQrGVvSKBGaZ5VHwhhN50kT8BuKCV
 JZddFRJl4aYrk6aNoN1CG0FDwS6cClSV+5k7n2J29piLfmygmNAPtQySL7MSMLKTnODsDeM
 J7NIaL6jpsf4IUnYb3R/RlTlhN7fEoTLURknE/kkplNM4d/MwrpNtIR6/PX5+pkVwGy3wls
 jDMfykMB8FQAO40T1hvyQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z0PcPGDkBl8=:j9dkBSEwZ6RdMHLYYX0ABa
 8W88XeY064qXbiESksq2D2GdbnjkFrcVZhX7SelvHLsh4mAYaNV3H74e7YnTfH3wT3dAzCHfr
 ZhekqOw9qo5YchIBMvwHE0UK1dXDPGI6Lwmn233Ce2a14ih+OHIqgA5qN9D6XhA2m14G7ZQI8
 8l2mJrJm5WRiuVLVYg4M3YHbMKifhWw9wxkDeqJ3zIrcoFyTt422tUyhkq0JNEtkptzAFOzuk
 nvOc/2nvTQhU56KPcOkSwrcMh2dNI14eK0e4TtBJehW7DsFK9uLb96LvD/J36PHgpccpKZaF3
 vxC877hGij2gMWKumEOVxsPoNVC+mze/CKY82kYvxSRyL0lzs6QWojhpEMQ/LBNbqO3L56dKf
 0RB7gKHZcechwhK13ia2Giuj0zMhVAQk2jQwgGpe4KPzm9yPTMX/UpjQwUwstNyrELw++zyT5
 I/37gAqVjKE0BCbB2iunOOO1yTh9PI0HF04VaWHlpb3EUfR5p4NSn2IOtlGk82g7WbaD1wg7W
 V7aH3imfAy5ahdwswiFrziY6br01AyKuWC881/d3DnT3ADSbCaU13OJd7rXzADFA6ycc/8zle
 5fru7HLNZAMAoB6xSIst+LLgRVlI4/IAqk1K2Awhyk/YGGSdIOpn6g27OXwMKgcv+2oQ2C+8r
 PYGho8AQDTlq2Xc6uND1OoPgVDGPhoJ6F7aytN8GQqQ0kOJQdi3WHSAUnB7cl098xyKBK3hNZ
 Wlc28AtaIGBtkTxE76dfT/wS2qj+4wgcdWyfdO/c0EotbsY0zSpgZb5aiYrXnfWlZWwat3ZA2
 eFbg43J36hjjqaJjwTdaO8pYPaDeyZhN2bJh8dnQuP3cG7PPHn54YCmnfxYQXAx9lBAlB3d

On Wed, Jul 8, 2020 at 3:04 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> w=
rote:
> On 08/07/2020 10:57, Arnd Bergmann wrote:
> > On Tue, Jul 7, 2020 at 8:10 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
> >
> > It looks like all you need here today is a single argument bit, plus
> > possibly some room for extensibility. I would suggest removing all
> > the extra bits and using a syscall like
> >
> > SYSCALL_DEFINE1(landlock_create_ruleset, u32, flags);
> >
> > I don't really see how this needs any variable-length arguments,
> > it really doesn't do much.
>
> We need the attr_ptr/attr_size pattern because the number of ruleset
> properties will increase (e.g. network access mask).

But how many bits do you think you will *actually* need in total that
this needs to be a two-dimensional set of flags? At the moment you
only have a single bit that you interpret.

> > To be on the safe side, you might split up the flags into either the
> > upper/lower 16 bits or two u32 arguments, to allow both compatible
> > (ignored by older kernels if flag is set) and incompatible (return erro=
r
> > when an unknown flag is set) bits.
>
> This may be a good idea in general, but in the case of Landlock, because
> this kind of (discretionary) sandboxing should be a best-effort security
> feature, we should avoid incompatible behavior. In practice, every
> unknown bit returns an error because userland can probe for available
> bits thanks to the get_features command. This kind of (in)compatibility
> can then be handled by userland.

If there are not going to be incompatible extensions, then just ignore
all unknown bits and never return an error but get rid of the user
space probing that just complicates the interface.

In general, it's hard to rely on user space to first ask the kernel
what it can do, the way this normally works is that user space
asks the kernel for something and it either does it or not, but gives
an indication of whether it worked.

> I suggest this syscall signature:
> SYSCALL_DEFINE3(landlock_create_ruleset, __u32, options, const struct
> landlock_attr_ruleset __user *, ruleset_ptr, size_t, ruleset_size);

The other problem here is that indirect variable-size structured arguments
are a pain to instrument with things like strace or seccomp, so you
should first try to use a fixed argument list, and fall back to a fixed
structure if that fails.

> >> +static int syscall_add_rule_path_beneath(const void __user *const att=
r_ptr,
> >> +               const size_t attr_size)
> >> +{
> >> +       struct landlock_attr_path_beneath attr_path_beneath;
> >> +       struct path path;
> >> +       struct landlock_ruleset *ruleset;
> >> +       int err;
> >
> > Similarly, it looks like this wants to be
> >
> > SYSCALL_DEFINE3(landlock_add_rule_path_beneath, int, ruleset, int,
> > path, __u32, flags)
> >
> > I don't see any need to extend this in a way that wouldn't already
> > be served better by adding another system call. You might argue
> > that 'flags' and 'allowed_access' could be separate, with the latter
> > being an indirect in/out argument here, like
> >
> > SYSCALL_DEFINE4(landlock_add_rule_path_beneath, int, ruleset, int, path=
,
> >                            __u64 *, allowed_acces, __u32, flags)
>
> To avoid adding a new syscall for each new rule type (e.g. path_beneath,
> path_range, net_ipv4_range, etc.), I think it would be better to keep
> the attr_ptr/attr_size pattern and to explicitely set a dedicated option
> flag to specify the attr type.
>
> This would look like this:
> SYSCALL_DEFINE4(landlock_add_rule, __u32, options, int, ruleset, const
> void __user *, rule_ptr, size_t, rule_size);
>
> The rule_ptr could then point to multiple types like struct
> landlock_attr_path_beneath (without the current ruleset_fd field).

This again introduces variable-sized structured data. How many different
kinds of rule types do you think there will be (most likely, and maybe an
upper bound)?

Could (some of) these be generalized to use the same data structure?

> >> +static int syscall_enforce_ruleset(const void __user *const attr_ptr,
> >> +               const size_t attr_size)
> >
> > Here it seems like you just need to pass the file descriptor, or maybe
> >
> > SYSCALL_DEFINE2(landlock_enforce, int, ruleset, __u32 flags);
> >
> > if you need flags for extensibility.
>
> Right, but for consistency I prefer to change the arguments like this:
> SYSCALL_DEFINE2(landlock_enforce, __u32 options, int, ruleset);

Most system calls pass the object they work on as the first argument,
in this case this would be the ruleset file descriptor.

     Arnd
