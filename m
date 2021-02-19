Return-Path: <SRS0=YnBa=HV=lists.openwall.com=kernel-hardening-return-20766-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7ED3C433DB
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Feb 2021 15:34:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1576564E67
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Feb 2021 15:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1576564E67
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hallyn.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20766-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18416 invoked by uid 550); 19 Feb 2021 15:34:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18381 invoked from network); 19 Feb 2021 15:34:25 -0000
Date: Fri, 19 Feb 2021 09:34:14 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
	Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v28 07/12] landlock: Support filesystem access-control
Message-ID: <20210219153414.GA18061@mail.hallyn.com>
References: <20210202162710.657398-1-mic@digikod.net>
 <20210202162710.657398-8-mic@digikod.net>
 <20210210193624.GA29893@mail.hallyn.com>
 <aeba97b6-37cd-4870-0a40-3e7aa84ebd36@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeba97b6-37cd-4870-0a40-3e7aa84ebd36@digikod.net>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Wed, Feb 10, 2021 at 09:17:25PM +0100, Mickaël Salaün wrote:
> 
> On 10/02/2021 20:36, Serge E. Hallyn wrote:
> > On Tue, Feb 02, 2021 at 05:27:05PM +0100, Mickaël Salaün wrote:
> >> From: Mickaël Salaün <mic@linux.microsoft.com>
> >>
> >> Thanks to the Landlock objects and ruleset, it is possible to identify
> >> inodes according to a process's domain.  To enable an unprivileged
> > 
> > This throws me off a bit.  "identify inodes according to a process's domain".
> > What exactly does it mean?  "identify" how ?
> 
> A domain is a set of rules (i.e. layers of rulesets) enforced on a set
> of threads. Inodes are tagged per domain (i.e. not system-wide) and
> actions are restricted thanks to these tags, which form rules. It means
> that the created access-controls are scoped to a set of threads.

Thanks, that's helpful.  To me it would be much clearer if you used the word
'tagged' :

  Using the Landlock objects and ruleset, it is possible to tag inodes
  according to a process's domain.

> >> process to express a file hierarchy, it first needs to open a directory
> >> (or a file) and pass this file descriptor to the kernel through
> >> landlock_add_rule(2).  When checking if a file access request is
> >> allowed, we walk from the requested dentry to the real root, following
> >> the different mount layers.  The access to each "tagged" inodes are
> >> collected according to their rule layer level, and ANDed to create
> >> access to the requested file hierarchy.  This makes possible to identify
> >> a lot of files without tagging every inodes nor modifying the
> >> filesystem, while still following the view and understanding the user
> >> has from the filesystem.
> >>
> >> Add a new ARCH_EPHEMERAL_INODES for UML because it currently does not
> >> keep the same struct inodes for the same inodes whereas these inodes are
> >> in use.
> > 
> > -serge
> > 
