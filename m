Return-Path: <SRS0=DLH3=BB=lists.openwall.com=kernel-hardening-return-19410-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AF7C433E6
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 16:20:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F11EB2065F
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 16:20:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F11EB2065F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=clip-os.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19410-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28518 invoked by uid 550); 22 Jul 2020 16:20:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27955 invoked from network); 22 Jul 2020 16:17:01 -0000
X-Originating-IP: 90.63.246.187
Date: Wed, 22 Jul 2020 18:16:39 +0200
From: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
To: Kees Cook <keescook@chromium.org>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 5/7] fs,doc: Enable to enforce noexec mounts or file
 exec through O_MAYEXEC
Message-ID: <20200722161639.GA24129@gandi.net>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-6-mic@digikod.net>
 <202007151312.C28D112013@keescook>
 <35ea0914-7360-43ab-e381-9614d18cceba@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35ea0914-7360-43ab-e381-9614d18cceba@digikod.net>

On Thu, Jul 16, 2020 at 04:39:14PM +0200, Mickaël Salaün wrote:
> 
> On 15/07/2020 22:37, Kees Cook wrote:
> > On Tue, Jul 14, 2020 at 08:16:36PM +0200, Mickaël Salaün wrote:
> >> @@ -2849,7 +2855,7 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> >>  	case S_IFLNK:
> >>  		return -ELOOP;
> >>  	case S_IFDIR:
> >> -		if (acc_mode & (MAY_WRITE | MAY_EXEC))
> >> +		if (acc_mode & (MAY_WRITE | MAY_EXEC | MAY_OPENEXEC))
> >>  			return -EISDIR;
> >>  		break;
> > 
> > (I need to figure out where "open for reading" rejects S_IFDIR, since
> > it's clearly not here...)

Doesn't it come from generic_read_dir() in fs/libfs.c?

> > 
> >>  	case S_IFBLK:
> >> @@ -2859,13 +2865,26 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> >>  		fallthrough;
> >>  	case S_IFIFO:
> >>  	case S_IFSOCK:
> >> -		if (acc_mode & MAY_EXEC)
> >> +		if (acc_mode & (MAY_EXEC | MAY_OPENEXEC))
> >>  			return -EACCES;
> >>  		flag &= ~O_TRUNC;
> >>  		break;
> > 
> > This will immediately break a system that runs code with MAY_OPENEXEC
> > set but reads from a block, char, fifo, or socket, even in the case of
> > a sysadmin leaving the "file" sysctl disabled.
> 
> As documented, O_MAYEXEC is for regular files. The only legitimate use
> case seems to be with pipes, which should probably be allowed when
> enforcement is disabled.

By the way Kees, while we fix that for the next series, do you think it
would be relevant, at least for the sake of clarity, to add a
WARN_ON_ONCE(acc_mode & MAY_OPENEXEC) for the S_IFSOCK case, since a
socket cannot be open anyway?

-- 
Thibaut Sautereau
CLIP OS developer
