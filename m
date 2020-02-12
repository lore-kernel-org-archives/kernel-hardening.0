Return-Path: <SRS0=soz3=4A=lists.openwall.com=kernel-hardening-return-17800-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08385C352A4
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 19:47:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6411224649
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 19:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6411224649
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17800-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30711 invoked by uid 550); 12 Feb 2020 19:47:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30671 invoked from network); 12 Feb 2020 19:47:49 -0000
Date: Wed, 12 Feb 2020 19:47:28 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs
 instances
Message-ID: <20200212194728.GM23230@ZenIV.linux.org.uk>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-8-gladkov.alexey@gmail.com>
 <87v9odlxbr.fsf@x220.int.ebiederm.org>
 <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
 <87tv3vkg1a.fsf@x220.int.ebiederm.org>
 <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Feb 12, 2020 at 10:45:06AM -0800, Linus Torvalds wrote:
> On Wed, Feb 12, 2020 at 7:01 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > Fundamentally proc_flush_task is an optimization.  Just getting rid of
> > dentries earlier.  At least at one point it was an important
> > optimization because the old process dentries would just sit around
> > doing nothing for anyone.
> 
> I'm pretty sure it's still important. It's very easy to generate a
> _ton_ of dentries with /proc.
> 
> > I wonder if instead of invalidating specific dentries we could instead
> > fire wake up a shrinker and point it at one or more instances of proc.
> 
> It shouldn't be the dentries themselves that are a freeing problem.
> They're being RCU-free'd anyway because of lookup. It's the
> proc_mounts list that is the problem, isn't it?
> 
> So it's just fs_info that needs to be rcu-delayed because it contains
> that list. Or is there something else?

Large part of the headache is the possibility that some joker has
done something like mounting tmpfs on /proc/<pid>/map_files, or
binding /dev/null on top of /proc/<pid>/syscall, etc.

IOW, that d_invalidate() can very well have to grab namespace_sem.
And possibly do a full-blown fs shutdown of something NFS-mounted,
etc...
