Return-Path: <SRS0=ww9F=4A=lists.openwall.com=kernel-hardening-return-17794-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC256C2BA83
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 16:04:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D4902082F
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 16:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D4902082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17794-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7749 invoked by uid 550); 12 Feb 2020 16:03:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7722 invoked from network); 12 Feb 2020 16:03:53 -0000
Date: Wed, 12 Feb 2020 17:03:39 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>
Subject: Re: [PATCH v8 10/11] docs: proc: add documentation for "hidepid=4"
 and "subset=pidfs" options and new mount behavior
Message-ID: <20200212160339.q6pm5zmjy5mfnvcr@comp-core-i7-2640m-0182e6>
Mail-Followup-To: Andy Lutomirski <luto@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-11-gladkov.alexey@gmail.com>
 <CALCETrWOXXYy5fo+D0wVBEviyk38ACqvO5Fep_oTEY6+UrS=4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWOXXYy5fo+D0wVBEviyk38ACqvO5Fep_oTEY6+UrS=4g@mail.gmail.com>

On Mon, Feb 10, 2020 at 10:29:23AM -0800, Andy Lutomirski wrote:
> On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> > ---
> >  Documentation/filesystems/proc.txt | 53 ++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> >
> > diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> > index 99ca040e3f90..4741fd092f36 100644
> > --- a/Documentation/filesystems/proc.txt
> > +++ b/Documentation/filesystems/proc.txt
> > @@ -50,6 +50,8 @@ Table of Contents
> >    4    Configuring procfs
> >    4.1  Mount options
> >
> > +  5    Filesystem behavior
> > +
> >  ------------------------------------------------------------------------------
> >  Preface
> >  ------------------------------------------------------------------------------
> > @@ -2021,6 +2023,7 @@ The following mount options are supported:
> >
> >         hidepid=        Set /proc/<pid>/ access mode.
> >         gid=            Set the group authorized to learn processes information.
> > +       subset=         Show only the specified subset of procfs.
> >
> >  hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
> >  (default).
> > @@ -2042,6 +2045,56 @@ information about running processes, whether some daemon runs with elevated
> >  privileges, whether other user runs some sensitive program, whether other users
> >  run any program at all, etc.
> >
> > +hidepid=4 means that procfs should only contain /proc/<pid>/ directories
> > +that the caller can ptrace.
> 
> I have a couple of minor nits here.
> 
> First, perhaps we could stop using magic numbers and use words.
> hidepid=ptraceable is actually comprehensible, whereas hidepid=4
> requires looking up what '4' means.

Do you mean to add string aliases for the values?

hidepid=0 == hidepid=default
hidepid=1 == hidepid=restrict
hidepid=2 == hidepid=ownonly
hidepid=4 == hidepid=ptraceable

Something like that ?

> Second, there is PTRACE_MODE_ATTACH and PTRACE_MODE_READ.  Which is it?

This is PTRACE_MODE_READ.

> > +
> >  gid= defines a group authorized to learn processes information otherwise
> >  prohibited by hidepid=.  If you use some daemon like identd which needs to learn
> >  information about processes information, just add identd to this group.
> 
> How is this better than just creating an entirely separate mount a
> different hidepid and a different gid owning it?

I'm not sure I understand the question. Now you cannot have two proc with
different hidepid in the same pid_namespace. 

> In any event,
> usually gid= means that this gid is the group owner of inodes.  Let's
> call it something different.  gid_override_hidepid might be credible.
> But it's also really weird -- do different groups really see different
> contents when they read a directory?

If you use hidepid=2,gid=wheel options then the user is not in the wheel
group will see only their processes and the user in the wheel group will
see whole tree. The gid= is a kind of whitelist for hidepid=1|2.

-- 
Rgrds, legion

