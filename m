Return-Path: <SRS0=OTaT=GR=lists.openwall.com=kernel-hardening-return-20648-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04F6C433DB
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 22:43:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BBD52339E
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 22:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BBD52339E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20648-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9642 invoked by uid 550); 14 Jan 2021 22:43:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9610 invoked from network); 14 Jan 2021 22:43:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l0aLIrK9Ls3yChluxnDYpvoAFnbmuAeFSQRaGDSDK6s=;
        b=Xp2UG1bDqZV6MWUIg3PXRWlOxm3AESTgyUaOByzy05KbBMIlWQTWhAjiAXqIJLco8n
         CKATzDajP+/i7+U9T8QSEVzVCGM9KCooEF2Qog6oGaP7m4UbxqlPABfgxbuvEWJTi9CN
         eqzQu31AW2vsl1w6jVkXxJ/M5h/fqc7PNe9pqO61lRW1/nWovu8unaTR5XmmIZkfZgwP
         tr+Axa7VGzhhKFDPvqTzv2L+EqZ4C5BEDY31jsINoIDSNsVV2C0gKRsxVsVvX38Zs0wH
         p15PatmNXOKYvYVm9VjZ1UxZrw3YprkBpqifeMBtnXs/ATFse8XhCqZ+GPH/cm/nlJcE
         s4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l0aLIrK9Ls3yChluxnDYpvoAFnbmuAeFSQRaGDSDK6s=;
        b=mWldLBIMuvg0lHb7AAUQv7bKXpgO1S9s0WMB2j54V/HQzLUHfYCydVcxygRQVi1bA+
         gPXpMlBx2zk9ddnm0sUDGVKILA6Atm3Nzj+keQvpM4FMOWdeVT2K/BMXByxj1vKOaNMg
         fB1BhwV+yzRt8tQO1fMMG1HoftEcFWWhJIkHwco6z3wroQ1BNgSL56h8x04tIYoOdQGB
         gdXYTZb9UB4A1jooy8psMsRZkN/y/kWkszhaNgGcBMAM+2ryzXZjpww4ZDb+N6OxsJKT
         B3Y59jyB5tIO+5qObbNYi/VT6+/mZ9mBHNdBtjoQ5BO8nfVKiumN7Of7eXT6YjF7syej
         vYzw==
X-Gm-Message-State: AOAM530kz70QD0CF5bK0btONVw4JjJoTj3ij4+0n4Ag575Q3/ZN2s+2w
	csflY9Ja6QwErQId6WlJjzWGfRGi0qgQsAtWY+w9fQ==
X-Google-Smtp-Source: ABdhPJwmu2cBfmtpdruzglhRIadtD3T+wRN+tSM4C2y7Zg3rHsx1RPPVdIX6GIoHvdQgt3ctrnlKrS5mVOsEqS6Krko=
X-Received: by 2002:a2e:50c:: with SMTP id 12mr4154104ljf.226.1610664208863;
 Thu, 14 Jan 2021 14:43:28 -0800 (PST)
MIME-Version: 1.0
References: <20201209192839.1396820-1-mic@digikod.net> <20201209192839.1396820-8-mic@digikod.net>
 <CAG48ez1wbAQwU-eoC9DngHyUM_5F01MJQpRnLaJFvfRUrnXBdA@mail.gmail.com> <aeb3e152-8108-89d2-0577-4b130368f14f@digikod.net>
In-Reply-To: <aeb3e152-8108-89d2-0577-4b130368f14f@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Thu, 14 Jan 2021 23:43:02 +0100
Message-ID: <CAG48ez2HJCFvmFALDYDYnufE755Dqh3JquAMf-1mnzmRrdKaoQ@mail.gmail.com>
Subject: Re: [PATCH v26 07/12] landlock: Support filesystem access-control
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Jeff Dike <jdike@addtoit.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14, 2021 at 7:54 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> On 14/01/2021 04:22, Jann Horn wrote:
> > On Wed, Dec 9, 2020 at 8:28 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
> >> Thanks to the Landlock objects and ruleset, it is possible to identify
> >> inodes according to a process's domain.  To enable an unprivileged
> >> process to express a file hierarchy, it first needs to open a director=
y
> >> (or a file) and pass this file descriptor to the kernel through
> >> landlock_add_rule(2).  When checking if a file access request is
> >> allowed, we walk from the requested dentry to the real root, following
> >> the different mount layers.  The access to each "tagged" inodes are
> >> collected according to their rule layer level, and ANDed to create
> >> access to the requested file hierarchy.  This makes possible to identi=
fy
> >> a lot of files without tagging every inodes nor modifying the
> >> filesystem, while still following the view and understanding the user
> >> has from the filesystem.
> >>
> >> Add a new ARCH_EPHEMERAL_INODES for UML because it currently does not
> >> keep the same struct inodes for the same inodes whereas these inodes a=
re
> >> in use.
> >>
> >> This commit adds a minimal set of supported filesystem access-control
> >> which doesn't enable to restrict all file-related actions.  This is th=
e
> >> result of multiple discussions to minimize the code of Landlock to eas=
e
> >> review.  Thanks to the Landlock design, extending this access-control
> >> without breaking user space will not be a problem.  Moreover, seccomp
> >> filters can be used to restrict the use of syscall families which may
> >> not be currently handled by Landlock.
> > [...]
> >> +static bool check_access_path_continue(
> >> +               const struct landlock_ruleset *const domain,
> >> +               const struct path *const path, const u32 access_reques=
t,
> >> +               u64 *const layer_mask)
> >> +{
> > [...]
> >> +       /*
> >> +        * An access is granted if, for each policy layer, at least on=
e rule
> >> +        * encountered on the pathwalk grants the access, regardless o=
f their
> >> +        * position in the layer stack.  We must then check not-yet-se=
en layers
> >> +        * for each inode, from the last one added to the first one.
> >> +        */
> >> +       for (i =3D 0; i < rule->num_layers; i++) {
> >> +               const struct landlock_layer *const layer =3D &rule->la=
yers[i];
> >> +               const u64 layer_level =3D BIT_ULL(layer->level - 1);
> >> +
> >> +               if (!(layer_level & *layer_mask))
> >> +                       continue;
> >> +               if ((layer->access & access_request) !=3D access_reque=
st)
> >> +                       return false;
> >> +               *layer_mask &=3D ~layer_level;
> >
> > Hmm... shouldn't the last 5 lines be replaced by the following?
> >
> > if ((layer->access & access_request) =3D=3D access_request)
> >     *layer_mask &=3D ~layer_level;
> >
> > And then, since this function would always return true, you could
> > change its return type to "void".
> >
> >
> > As far as I can tell, the current version will still, if a ruleset
> > looks like this:
> >
> > /usr read+write
> > /usr/lib/ read
> >
> > reject write access to /usr/lib, right?
>
> If these two rules are from different layers, then yes it would work as
> intended. However, if these rules are from the same layer the path walk
> will not stop at /usr/lib but go down to /usr, which grants write
> access.

I don't see why the code would do what you're saying it does. And an
experiment seems to confirm what I said; I checked out landlock-v26,
and the behavior I get is:

user@vm:~/landlock$ dd if=3D/dev/null of=3D/tmp/aaa
0+0 records in
0+0 records out
0 bytes copied, 0.00106365 s, 0.0 kB/s
user@vm:~/landlock$ LL_FS_RO=3D'/lib' LL_FS_RW=3D'/' ./sandboxer dd
if=3D/dev/null of=3D/tmp/aaa
0+0 records in
0+0 records out
0 bytes copied, 0.000491814 s, 0.0 kB/s
user@vm:~/landlock$ LL_FS_RO=3D'/tmp' LL_FS_RW=3D'/' ./sandboxer dd
if=3D/dev/null of=3D/tmp/aaa
dd: failed to open '/tmp/aaa': Permission denied
user@vm:~/landlock$

Granting read access to /tmp prevents writing to it, even though write
access was granted to /.
