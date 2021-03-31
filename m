Return-Path: <SRS0=J2HT=I5=lists.openwall.com=kernel-hardening-return-21094-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9F9C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 06:34:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7DA89619BB
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 06:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DA89619BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21094-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13423 invoked by uid 550); 31 Mar 2021 06:33:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13394 invoked from network); 31 Mar 2021 06:33:58 -0000
Date: Wed, 31 Mar 2021 06:33:02 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	James Morris <jmorris@namei.org>, Serge Hallyn <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	John Johansen <john.johansen@canonical.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v5 1/1] fs: Allow no_new_privs tasks to call chroot(2)
Message-ID: <YGQXnqNsG0iUljvk@zeniv-ca.linux.org.uk>
References: <20210316203633.424794-1-mic@digikod.net>
 <20210316203633.424794-2-mic@digikod.net>
 <fef10d28-df59-640e-ecf7-576f8348324e@digikod.net>
 <85ebb3a1-bd5e-9f12-6d02-c08d2c0acff5@schaufler-ca.com>
 <b47f73fe-1e79-ff52-b93e-d86b2927bbdc@digikod.net>
 <77ec5d18-f88e-5c7c-7450-744f69654f69@schaufler-ca.com>
 <a8b2545f-51c7-01dc-1a14-e87beefc5419@digikod.net>
 <2fcff3d7-e7ca-af3b-9306-d8ef2d3fb4fb@schaufler-ca.com>
 <202103302249.6FE62C03@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202103302249.6FE62C03@keescook>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Mar 30, 2021 at 11:03:10PM -0700, Kees Cook wrote:

> Regardless, I still endorse this change because it doesn't make things
> _worse_, since without this, a compromised process wouldn't need ANY
> tricks to escape a chroot because it wouldn't be in one. :) It'd be nice
> if there were some way to make future openat() calls be unable to
> resolve outside the chroot, but I view that as an enhancement.
> 
> But, as it stands, I think this makes sense and I stand by my
> Reviewed-by tag. If Al is too busy to take it, and James would rather
> not take VFS, perhaps akpm would carry it? That's where other similar
> VFS security work has landed.

Frankly, I'm less than fond of that thing, but right now I'm buried
under all kinds of crap (->d_revalidate() joy, mostly).  I'll post
a review, but for now it's very definitely does *not* get an implicit
ACK from me.
