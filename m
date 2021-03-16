Return-Path: <SRS0=sVFy=IO=lists.openwall.com=kernel-hardening-return-20949-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DECC433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 18:43:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5F6FE650EF
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 18:43:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F6FE650EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20949-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5601 invoked by uid 550); 16 Mar 2021 18:43:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5581 invoked from network); 16 Mar 2021 18:43:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OptPjRnwjXC7zKbUBkw8dw6CLa96GSPlm9wOKUYzD7E=;
        b=dCguvI+VWcGOGobPRiPVUdxUKgZvETSN+uJx0tokpIzqQM7+LmH15/c5uSWcXJmc0e
         +x08CsN0VFPVtk/HBfRMKXWIPypf+5ywRpGhkC173FdfoKCV/OVegFVHgMF4tVUEw2Rr
         zWV2O615wxmjD8JuHbVV4hcka6k1YXb+hR0Jg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OptPjRnwjXC7zKbUBkw8dw6CLa96GSPlm9wOKUYzD7E=;
        b=SkgTjDvvSzpH5S5QWp4zKTYpXyfOV2KsHuT5tNcEh26xNS9/M7HdjU8AUy3ICASFBe
         9X5Q2GaEyPMcAiXn6XZsQAJx5Di8gpNAv81gqL/xXCJba+N82tpjvAN+PKI9uFPalJZr
         lkaRtV/D4ujnKIuxIQy768TMldkQhKvUKsgUkkf0BtkpuY3HfcNP4WwF38XrgmozCb7H
         htg5AiGzvLwSdk/UK8jCyMcVjz5GnlnzvHrGOzDNTaY22+3pzB9HjcxLl3BxHgrduph3
         FdudVTRmnHDZe7u5F+RBLvj2dFUqdc6p9YE8BERgWFvW97Z1hqK+RvczWEVPdOd2Gs7E
         1qww==
X-Gm-Message-State: AOAM530Ar87b7mf34wqmj7Ub9zTDhtvhppRs6QjeCzs0FKPwocC/XIgp
	syTNPXjb6ftDjdMwTpP9uHrQ1A==
X-Google-Smtp-Source: ABdhPJwzSyncb7aVwdO7wN2RK69tEVNBlE46/Vv8k3A1+x6MrWslekElUXeJaOlfySU5pV7XBEELzg==
X-Received: by 2002:a17:902:bb8e:b029:e6:3b2:5834 with SMTP id m14-20020a170902bb8eb02900e603b25834mr869082pls.38.1615920187759;
        Tue, 16 Mar 2021 11:43:07 -0700 (PDT)
Date: Tue, 16 Mar 2021 11:43:06 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
	Serge Hallyn <serge@hallyn.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	John Johansen <john.johansen@canonical.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v4 1/1] fs: Allow no_new_privs tasks to call chroot(2)
Message-ID: <202103161142.87100A8133@keescook>
References: <20210316170135.226381-1-mic@digikod.net>
 <20210316170135.226381-2-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316170135.226381-2-mic@digikod.net>

On Tue, Mar 16, 2021 at 06:01:35PM +0100, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Being able to easily change root directories enables to ease some
> development workflow and can be used as a tool to strengthen
> unprivileged security sandboxes.  chroot(2) is not an access-control
> mechanism per se, but it can be used to limit the absolute view of the
> filesystem, and then limit ways to access data and kernel interfaces
> (e.g. /proc, /sys, /dev, etc.).
> 
> Users may not wish to expose namespace complexity to potentially
> malicious processes, or limit their use because of limited resources.
> The chroot feature is much more simple (and limited) than the mount
> namespace, but can still be useful.  As for containers, users of
> chroot(2) should take care of file descriptors or data accessible by
> other means (e.g. current working directory, leaked FDs, passed FDs,
> devices, mount points, etc.).  There is a lot of literature that discuss
> the limitations of chroot, and users of this feature should be aware of
> the multiple ways to bypass it.  Using chroot(2) for security purposes
> can make sense if it is combined with other features (e.g. dedicated
> user, seccomp, LSM access-controls, etc.).
> 
> One could argue that chroot(2) is useless without a properly populated
> root hierarchy (i.e. without /dev and /proc).  However, there are
> multiple use cases that don't require the chrooting process to create
> file hierarchies with special files nor mount points, e.g.:
> * A process sandboxing itself, once all its libraries are loaded, may
>   not need files other than regular files, or even no file at all.
> * Some pre-populated root hierarchies could be used to chroot into,
>   provided for instance by development environments or tailored
>   distributions.
> * Processes executed in a chroot may not require access to these special
>   files (e.g. with minimal runtimes, or by emulating some special files
>   with a LD_PRELOADed library or seccomp).
> 
> Unprivileged chroot is especially interesting for userspace developers
> wishing to harden their applications.  For instance, chroot(2) and Yama
> enable to build a capability-based security (i.e. remove filesystem
> ambient accesses) by calling chroot/chdir with an empty directory and
> accessing data through dedicated file descriptors obtained with
> openat2(2) and RESOLVE_BENEATH/RESOLVE_IN_ROOT/RESOLVE_NO_MAGICLINKS.
> 
> Allowing a task to change its own root directory is not a threat to the
> system if we can prevent confused deputy attacks, which could be
> performed through execution of SUID-like binaries.  This can be
> prevented if the calling task sets PR_SET_NO_NEW_PRIVS on itself with
> prctl(2).  To only affect this task, its filesystem information must not
> be shared with other tasks, which can be achieved by not passing
> CLONE_FS to clone(2).  A similar no_new_privs check is already used by
> seccomp to avoid the same kind of security issues.  Furthermore, because
> of its security use and to avoid giving a new way for attackers to get
> out of a chroot (e.g. using /proc/<pid>/root, or chroot/chdir), an
> unprivileged chroot is only allowed if the calling process is not
> already chrooted.  This limitation is the same as for creating user
> namespaces.
> 
> This change may not impact systems relying on other permission models
> than POSIX capabilities (e.g. Tomoyo).  Being able to use chroot(2) on
> such systems may require to update their security policies.
> 
> Only the chroot system call is relaxed with this no_new_privs check; the
> init_chroot() helper doesn't require such change.
> 
> Allowing unprivileged users to use chroot(2) is one of the initial
> objectives of no_new_privs:
> https://www.kernel.org/doc/html/latest/userspace-api/no_new_privs.html
> This patch is a follow-up of a previous one sent by Andy Lutomirski:
> https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net/
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: John Johansen <john.johansen@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>

Thanks for the updates! I find this version much easier to read. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
