Return-Path: <SRS0=Tw9y=4A=lists.openwall.com=kernel-hardening-return-17802-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79829C352A4
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 20:04:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D777621739
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 20:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D777621739
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17802-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10191 invoked by uid 550); 12 Feb 2020 20:03:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10149 invoked from network); 12 Feb 2020 20:03:53 -0000
Date: Wed, 12 Feb 2020 20:03:35 +0000
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
Message-ID: <20200212200335.GO23230@ZenIV.linux.org.uk>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-8-gladkov.alexey@gmail.com>
 <87v9odlxbr.fsf@x220.int.ebiederm.org>
 <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
 <87tv3vkg1a.fsf@x220.int.ebiederm.org>
 <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
 <87v9obipk9.fsf@x220.int.ebiederm.org>
 <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Feb 12, 2020 at 11:49:58AM -0800, Linus Torvalds wrote:

> I wonder if we could split up d_invalidate(). It already ends up being
> two phases: first the unhashing under the d_lock, and then the
> recursive shrinking of parents and children.
> 
> The recursive shrinking of the parent isn't actually interesting for
> the proc shrinking case: we just looked up one child, after all. So we
> only care about the d_walk of the children.
> 
> So if we only did the first part under the RCU lock, and just
> collected the dentries (can we perhaps then re-use the hash list to
> collect them to another list?) and then did the child d_walk
> afterwards?

What's to prevent racing with fs shutdown while you are doing the second part?
We could, after all, just have them[*] on procfs-private list (anchored in
task_struct) from the very beginning; evict on ->d_prune(), walk the list
on exit...  How do you make sure the fs instance won't go away right under
you while you are doing the real work?  Suppose you are looking at one
of those dentries and you've found something blocking to do.  You can't
pin that dentry; you can pin ->s_active on its superblock (if it's already
zero, you can skip it - fs shutdown already in progress will take care of
the damn thing), but that will lead to quite a bit of cacheline pingpong...

[*] only /proc/<pid> and /proc/*/task/<pid> dentries, obviously.
