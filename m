Return-Path: <SRS0=amhI=AT=lists.openwall.com=kernel-hardening-return-19252-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7BBC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 08:57:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B26B2220C
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 08:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B26B2220C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19252-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27985 invoked by uid 550); 8 Jul 2020 08:57:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27948 invoked from network); 8 Jul 2020 08:57:48 -0000
X-Gm-Message-State: AOAM530wKKhcoQ+9/PMCzP14FPQgNXGA3qkq5NTP9yTTEjn6NJlNhV8Z
	0IYWoe/saq4XaaBz3VFdysw59tVBaKO8WOVSpEo=
X-Google-Smtp-Source: ABdhPJzKe0ldZY51vXLPbQLnhFOs4GKMxEtmMtpTYVrKrkHsesQPcdu9/5x/KOYdqQi57WAW7hH524s3eVnRN1t9las=
X-Received: by 2002:a37:9dd6:: with SMTP id g205mr57834681qke.352.1594198654977;
 Wed, 08 Jul 2020 01:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200707180955.53024-1-mic@digikod.net> <20200707180955.53024-9-mic@digikod.net>
In-Reply-To: <20200707180955.53024-9-mic@digikod.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 8 Jul 2020 10:57:18 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0FkoxFtcQJ2jSqyLbDCOp3R8-1JoY8CWAgbSZ9hH9wdQ@mail.gmail.com>
Message-ID: <CAK8P3a0FkoxFtcQJ2jSqyLbDCOp3R8-1JoY8CWAgbSZ9hH9wdQ@mail.gmail.com>
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
X-Provags-ID: V03:K1:Fe94TjTSBPgZDTxndB91v8HLwbAyy3RwZsxwdMo6fn6UaTX3gn0
 ipsMXZltNBaE3Q2FF2EkEJ0mArS6Oh3yEWdnmYJ0gxQwMjSV0aTXMxCBwrwa4z9DoemFQLa
 au+AtksWq/OVHEXfz0pqx3ivrkC4anrf8ElHroCPzR9AGtmYlkLWxkVAFBPKyD3EZ9Kl37x
 u72sa4wgWFDmFYcqCYvPg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gD2tWGDg/TY=:0Ux5QV0DHPhYmcgBuFcQBi
 NxY1rbu12jmAGbV3mAVjCvm3GgopbDwUK4jHHlVMdpgYHR1+Co/VOFXyKhS5uEnFSJ1Uiz50X
 ik7wsLLY8R757H+vdxXtXmn/r84/bYLdAz/V6tP3DBrbHgStKTb+9jQ6ziTkEGbVT41aMs8Hm
 39N1sYQIlMKEJMrcZiDRQVTUA2TKsAGb5aZbri//iAWtkR/Jz+gmg11/CjvalFKdt4NZ+W2Vr
 i35zAy/UO5hnwWPn+lKS6Wg0Y1b5mfyUoSR3Y9glQJZS3xEPZG2WIDmMJocD4djxyZAKV07Y5
 mM7AJTzv3LF2DFRBhd/0/UDjzxdgR414IGhuF4LDK/aBVHuAcZXsUJg+0Y7Ok2676l7M7ctB6
 wStN+xfFUCHRd1FW1+vagtI6mvni5pwDQVkDTN+H2LjWxXEZGWLr+pPpUjVRbMjBTTs4QL8Fg
 bxowgK8FEmJDNJ9zm55Ey/bMZTun4lwMx/zVORAaZD50jxVTRKweepp+uMFMjbu8KIvOGY4F/
 SFUBWKfZOYfr5YFq0oZaqpWXdRUhgevJUhPTuU6l00pzT1pAa9DmsmUwhwTE3zSkLaTNuaP9N
 hLCAZVhuBsyv5aN6kVsWup1KuNEU+G/vFjViaW/SNl8HIUbZNcm2xKxsZlHJIO/vxxT2XM6ZY
 R5eespk5kj+3qeJcQc2SmJeOjQHOhNBQuSC2G8QBG6Z+ytirL4cr0g5IN1ffet8gu664EaH7L
 TNLy01s2oUSxP0MijxQGQbagV4wX1mD0A4/teJ0WwMAqDh/j7rr5O8TthoU8H5ggPb8UA9EcS
 4LbCC2Qnp2Eh7iVhdTWdWXIL6Xi8nmU+z7MgsJ4JjeRrCpDcf8Hm0vFOF2OoJuty7mCxH44+4
 DEdFLpJd/8I5i2NfIkt0JLrZAgTesvNG8r4ntBFyc+Nuq6ru8NVA5r6o9XjvDIVa/F1YhyneV
 8pQGx9Vr80ZDc7GP73HACqDD2qDrYS5j5Jm496bSD6+o86o3o9n2j

On Tue, Jul 7, 2020 at 8:10 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> w=
rote:
>
> This system call, inspired from seccomp(2) and bpf(2), is designed to be
> used by unprivileged processes to sandbox themselves.  It has the same
> usage restrictions as seccomp(2): the caller must have the no_new_privs
> attribute set or have CAP_SYS_ADMIN in the current user namespace.
>
> Here are the motivations for this new syscall:
> * A sandboxed process may not have access to file systems, including
>   /dev, /sys or /proc, but it should still be able to add more
>   restrictions to itself.
> * Neither prctl(2) nor seccomp(2) (which was used in a previous version)
>   fit well with the current definition of a Landlock security policy.
> * It is quite easy to whitelist this syscall with seccomp-bpf to enable
>   all processes to use it.  It is also easy to filter specific commands
>   or options to restrict a process to a subset of Landlock features.
>
> There is currently four commands:
> * LANDLOCK_CMD_GET_FEATURES: Gets the supported features (required for
>   backward and forward compatibility, and best-effort security).
> * LANDLOCK_CMD_CREATE_RULESET: Creates a ruleset and returns its file
>   descriptor.
> * LANDLOCK_CMD_ADD_RULE: Adds a rule (e.g. file hierarchy access) to a
>   ruleset, identified by the dedicated file descriptor.
> * LANDLOCK_CMD_ENFORCE_RULESET: Enforces a ruleset on the current thread
>   and its future children (similar to seccomp).

I never paid attention to the patch series so far, so I'm sorry if this
has all been discussed before, but I think the syscall prototype needs
to be different, with *much* less extensibility built in.

> Each command has at least one option, which enables to define the
> attribute types passed to the syscall.  All attribute types (structures)
> are checked at build time to ensure that they don't contain holes and
> that they are aligned the same way for each architecture.  The struct
> landlock_attr_features contains __u32 options_* fields which is enough
> to store 32-bits syscall arguments, and __u16 size_attr_* fields which
> is enough for the maximal struct size (i.e. page size) passed through
> the landlock syscall.  The other fields can have __u64 type for flags
> and bitfields, and __s32 type for file descriptors.
>
> See the user and kernel documentation for more details (provided by a
> following commit): Documentation/security/landlock/

System calls with their own sub-commands have turned out to be a
bad idea many times in the past and cause more problems than they
solve. See sys_ipc, sys_socketcall and sys_futex for common examples.

The first step I would recommend is to split out the individual commands
into separate syscalls. For each one of those, pick a simple prototype
that can do what it needs, with one 'flags' argument for extensibility.

> +/**
> + * DOC: options_intro
> + *
> + * These options may be used as second argument of sys_landlock().  Each
> + * command have a dedicated set of options, represented as bitmasks.  Fo=
r two
> + * different commands, their options may overlap.  Each command have at =
least
> + * one option defining the used attribute type.  This also enables to al=
ways
> + * have a usable &struct landlock_attr_features (i.e. filled with bits).
> + */
> +
> +/**
> + * DOC: options_get_features
> + *
> + * Options for ``LANDLOCK_CMD_GET_FEATURES``
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * - %LANDLOCK_OPT_GET_FEATURES: the attr type is `struct
> + *   landlock_attr_features`.
> + */
> +#define LANDLOCK_OPT_GET_FEATURES                      (1 << 0)

For each command, you currently have one attribute that is defined
to have a name directly corresponding to the command, making it
entirely redundant. I'd suggest just check the 'flags' argument for
being zero at syscall entry for future extension if you think there may
be a need to extend it, or completely leave out attributes and flags.

> +static int syscall_create_ruleset(const void __user *const attr_ptr,
> +               const size_t attr_size)
> +{
> +       struct landlock_attr_ruleset attr_ruleset;
> +       struct landlock_ruleset *ruleset;
> +       int err, ruleset_fd;
> +
> +       /* Copies raw user space buffer. */
> +       err =3D copy_struct_if_any_from_user(&attr_ruleset, sizeof(attr_r=
uleset),
> +                       offsetofend(typeof(attr_ruleset), handled_access_=
fs),
> +                       attr_ptr, attr_size);
> +       if (err)
> +               return err;
> +
> +       /* Checks content (and 32-bits cast). */
> +       if ((attr_ruleset.handled_access_fs | _LANDLOCK_ACCESS_FS_MASK) !=
=3D
> +                       _LANDLOCK_ACCESS_FS_MASK)
> +               return -EINVAL;
> +
> +       /* Checks arguments and transforms to kernel struct. */
> +       ruleset =3D landlock_create_ruleset(attr_ruleset.handled_access_f=
s);
> +       if (IS_ERR(ruleset))
> +               return PTR_ERR(ruleset);
> +
> +       /* Creates anonymous FD referring to the ruleset. */
> +       ruleset_fd =3D anon_inode_getfd("landlock-ruleset", &ruleset_fops=
,
> +                       ruleset, O_RDWR | O_CLOEXEC);
> +       if (ruleset_fd < 0)
> +               landlock_put_ruleset(ruleset);
> +       return ruleset_fd;
> +}

It looks like all you need here today is a single argument bit, plus
possibly some room for extensibility. I would suggest removing all
the extra bits and using a syscall like

SYSCALL_DEFINE1(landlock_create_ruleset, u32, flags);

I don't really see how this needs any variable-length arguments,
it really doesn't do much.

To be on the safe side, you might split up the flags into either the
upper/lower 16 bits or two u32 arguments, to allow both compatible
(ignored by older kernels if flag is set) and incompatible (return error
when an unknown flag is set) bits.

> +struct landlock_attr_path_beneath {
> +       /**
> +        * @ruleset_fd: File descriptor tied to the ruleset which should =
be
> +        * extended with this new access.
> +        */
> +       __s32 ruleset_fd;
> +       /**
> +        * @parent_fd: File descriptor, open with ``O_PATH``, which ident=
ify
> +        * the parent directory of a file hierarchy, or just a file.
> +        */
> +       __s32 parent_fd;
> +       /**
> +        * @allowed_access: Bitmask of allowed actions for this file hier=
archy
> +        * (cf. `Filesystem flags`_).
> +        */
> +       __u64 allowed_access;
> +};

> +static int syscall_add_rule_path_beneath(const void __user *const attr_p=
tr,
> +               const size_t attr_size)
> +{
> +       struct landlock_attr_path_beneath attr_path_beneath;
> +       struct path path;
> +       struct landlock_ruleset *ruleset;
> +       int err;

Similarly, it looks like this wants to be

SYSCALL_DEFINE3(landlock_add_rule_path_beneath, int, ruleset, int,
path, __u32, flags)

I don't see any need to extend this in a way that wouldn't already
be served better by adding another system call. You might argue
that 'flags' and 'allowed_access' could be separate, with the latter
being an indirect in/out argument here, like

SYSCALL_DEFINE4(landlock_add_rule_path_beneath, int, ruleset, int, path,
                           __u64 *, allowed_acces, __u32, flags)

> +static int syscall_enforce_ruleset(const void __user *const attr_ptr,
> +               const size_t attr_size)

Here it seems like you just need to pass the file descriptor, or maybe

SYSCALL_DEFINE2(landlock_enforce, int, ruleset, __u32 flags);

if you need flags for extensibility.

      Arnd
