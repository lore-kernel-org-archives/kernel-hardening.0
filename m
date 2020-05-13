Return-Path: <SRS0=oyjj=63=lists.openwall.com=kernel-hardening-return-18782-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2602EC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 May 2020 23:28:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 83C21205ED
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 May 2020 23:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Wa8oSycZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83C21205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18782-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1304 invoked by uid 550); 13 May 2020 23:27:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1284 invoked from network); 13 May 2020 23:27:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=La9vx7MorJZiXlhnoB2rsDbVVQSOuPLVZzpor9e1jzY=;
        b=Wa8oSycZdrRGG9QzrXLSvC3JtiTdaDaWMWTkLnJQoXczSccdfdpa/foDgwormTcGd3
         lCWEZlKy3aMd52zDNur9MoU3QPPOlOcYNR41xdzDe+rf1dGAB3b96ER0Jiw696cDQ6Jl
         XgDzqQNY94eOTZ2bsqEhqcwW5vrA6XRf62WuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=La9vx7MorJZiXlhnoB2rsDbVVQSOuPLVZzpor9e1jzY=;
        b=COl2p0fmdrvnvpZhNTalj+Hu3ueV5Pmak+xWh/KtFxwicckHcf7O0V8Dz5p06Ds9N+
         TIC/Eregw9plA6uUO2+t3dg9i8FrqoadXf7odvB4rTILPVonO5FZ9X+YghM3bwsEAmSB
         /WVWNmrZDxVm4SyBxqQhJbP1sGMDFziuVzWYsAzJTE+WRAfD/+R9fXsOqPWDk8oZ4niw
         B2kyLEe+KPeH21Rm6jek6TgvRS7muGqsbKL/Q5kviYhn6XebTUJVv6iquazYCojz+baV
         vfNOGceKUhUMz8fqzsXNzqOdQUnl1WDblHFkTp/FiyUmigPBnuKzHSNCZw1KiPOnSafl
         vVWQ==
X-Gm-Message-State: AGi0Pub+cqRcCNPbB53Bs/436tzhUFv1r2LT1VWltLOicIUPHblipah/
	ucEH5EOm3oMZ2YegTNdqxzLuiQ==
X-Google-Smtp-Source: APiQypIeI54Fvrp03N2maBa5wYVxGJm1Ex5179pufUMVk1LSHDGPtPwnQZGN9lE8wfIRPM/0r7V1NA==
X-Received: by 2002:a17:90b:2388:: with SMTP id mr8mr37723319pjb.107.1589412461619;
        Wed, 13 May 2020 16:27:41 -0700 (PDT)
Date: Wed, 13 May 2020 16:27:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	LSM List <linux-security-module@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
Message-ID: <202005131525.D08BFB3@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>

On Wed, May 13, 2020 at 11:37:16AM -0400, Stephen Smalley wrote:
> On Tue, May 5, 2020 at 11:33 AM Mickaël Salaün <mic@digikod.net> wrote:
> >
> > Enable to forbid access to files open with O_MAYEXEC.  Thanks to the
> > noexec option from the underlying VFS mount, or to the file execute
> > permission, userspace can enforce these execution policies.  This may
> > allow script interpreters to check execution permission before reading
> > commands from a file, or dynamic linkers to allow shared object loading.
> >
> > Add a new sysctl fs.open_mayexec_enforce to enable system administrators
> > to enforce two complementary security policies according to the
> > installed system: enforce the noexec mount option, and enforce
> > executable file permission.  Indeed, because of compatibility with
> > installed systems, only system administrators are able to check that
> > this new enforcement is in line with the system mount points and file
> > permissions.  A following patch adds documentation.
> >
> > For tailored Linux distributions, it is possible to enforce such
> > restriction at build time thanks to the CONFIG_OMAYEXEC_STATIC option.
> > The policy can then be configured with CONFIG_OMAYEXEC_ENFORCE_MOUNT and
> > CONFIG_OMAYEXEC_ENFORCE_FILE.
> >
> > Being able to restrict execution also enables to protect the kernel by
> > restricting arbitrary syscalls that an attacker could perform with a
> > crafted binary or certain script languages.  It also improves multilevel
> > isolation by reducing the ability of an attacker to use side channels
> > with specific code.  These restrictions can natively be enforced for ELF
> > binaries (with the noexec mount option) but require this kernel
> > extension to properly handle scripts (e.g., Python, Perl).  To get a
> > consistent execution policy, additional memory restrictions should also
> > be enforced (e.g. thanks to SELinux).
> >
> > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > Cc: Aleksa Sarai <cyphar@cyphar.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > ---
> 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 33b6d372e74a..70f179f6bc6c 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -411,10 +412,90 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
> <snip>
> > +#if defined(CONFIG_SYSCTL) && !defined(CONFIG_OMAYEXEC_STATIC)
> > +int proc_omayexec(struct ctl_table *table, int write, void __user *buffer,
> > +               size_t *lenp, loff_t *ppos)
> > +{
> > +       int error;
> > +
> > +       if (write) {
> > +               struct ctl_table table_copy;
> > +               int tmp_mayexec_enforce;
> > +
> > +               if (!capable(CAP_MAC_ADMIN))
> > +                       return -EPERM;
> 
> Not fond of using CAP_MAC_ADMIN here (or elsewhere outside of security
> modules).  The ability to set this sysctl is not equivalent to being
> able to load a MAC policy, set arbitrary MAC labels on
> processes/files, etc.

That's fair. In that case, perhaps this could just use the existing
_sysadmin helper? (Though I should note that these perm checks actually
need to be in the open, not the read/write ... I thought there was a
series to fix that, but I can't find it now. Regardless, that's
orthogonal to this series.)

> > + * omayexec_inode_permission - Check O_MAYEXEC before accessing an inode
> > + *
> > + * @inode: Inode to check permission on
> > + * @mask: Right to check for (%MAY_OPENEXEC, %MAY_EXECMOUNT, %MAY_EXEC)
> > + *
> > + * Returns 0 if access is permitted, -EACCES otherwise.
> > + */
> > +static inline int omayexec_inode_permission(struct inode *inode, int mask)
> > +{
> > +       if (!(mask & MAY_OPENEXEC))
> > +               return 0;
> > +
> > +       if ((sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT) &&
> > +                       !(mask & MAY_EXECMOUNT))
> > +               return -EACCES;
> > +
> > +       if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
> > +               return generic_permission(inode, MAY_EXEC);
> > +
> > +       return 0;
> > +}
> 
> I'm wondering if this is being done at the wrong level.  I would think
> that OMAYEXEC_ENFORCE_FILE would mean to check file execute permission
> with respect to all mechanisms/policies, including DAC,
> filesystem-specific checking (inode->i_op->permission), security
> modules, etc.  That requires more than just calling
> generic_permission() with MAY_EXEC, which only covers the default
> DAC/ACL logic; you'd need to take the handling up a level to
> inode_permission() and re-map MAY_OPENEXEC to MAY_EXEC for
> do_inode_permission() and security_inode_permission() at least.

Oh, yeah, that's a good point. Does this need to be a two-pass check, or
can MAY_OPENEXEC get expanded to MAY_EXEC here? Actually, why is this so
deep at all? Shouldn't this be in may_open()?

Like, couldn't just the entire thing just be:

diff --git a/fs/namei.c b/fs/namei.c
index a320371899cf..0ab18e19f5da 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2849,6 +2849,13 @@ static int may_open(const struct path *path, int acc_mode, int flag)
 		break;
 	}
 
+	if (unlikely(mask & MAY_OPENEXEC)) {
+		if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT &&
+		    path_noexec(path))
+			return -EACCES;
+		if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
+			acc_mode |= MAY_EXEC;
+	}
 	error = inode_permission(inode, MAY_OPEN | acc_mode);
 	if (error)
 		return error;

> Alternatively, we can modify each individual filesystem (that
> implements its own i_op->permission) and security module to start
> handling MAY_OPENEXEC and have them choose to remap it to a file
> execute check (or not) independent of the sysctl.  Not sure of your

Eek, no, this should be centralized in the VFS, not per-filesystem, but
I do see that it might be possible for a filesystem to actually do the
MAY_OPENEXEC test internally, so the two-pass check wouldn't be needed.
But... I think that can't happen until _everything_ can do the single
pass check, so we always have to make the second call too.

> intent.  As it stands, selinux_inode_permission() will ignore the new
> MAY_OPENEXEC flag until someone updates it.  Likewise for Smack.
> AppArmor/TOMOYO would probably need to check and handle FMODE_EXEC in
> their file_open hooks since they don't implement inode_permission().

Is there any need to teach anything about MAY_OPENEXEC? It'll show up
for the LSMs as (MAY_OPEN | MAY_EXEC).

-- 
Kees Cook
