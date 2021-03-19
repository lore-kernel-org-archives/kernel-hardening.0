Return-Path: <SRS0=9nQP=IR=lists.openwall.com=kernel-hardening-return-20990-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A4FC433DB
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:04:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADF0461950
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:04:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADF0461950
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20990-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27976 invoked by uid 550); 19 Mar 2021 18:03:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27949 invoked from network); 19 Mar 2021 18:03:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Fgm96KdkqPPp5AyePMeoZ4bVy8WajnICuOF6lgD+oIg=;
        b=WLn4qJw0mRnRd2MuhQP7t0sfnyhwEvjNu988xXSPLRxMyhbXuwpXBBTk46I7unAvON
         cjyhkk6qSlLOYR0UI87kTBxgP/Wnddx3aAKZdL5coNoywwluId0NvmkBbwQcv409IPbH
         mzySyBVh/E+KEz95rYinZ5MCAQ1HFNil/owiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Fgm96KdkqPPp5AyePMeoZ4bVy8WajnICuOF6lgD+oIg=;
        b=n5HaHCxaZA0iZu4ky79lFjrBksSMoaD0rqt19jx0/H85p8D+kPvM9rd+trC9p4A8nU
         W0lrLElDaH4d9hNTZI8ViHHZvx4gn0qRdriiJFYsynFBGCPcYUPwQMYjRfLx1cq/zItW
         DWUiHaB//airb3W2Uyeq8pV6F9NUdkuADvlZEBRMJO0AEMzhb1OwVe9qNNbk87usMaxA
         RAqATEwDX4EJt84XEecxG6Yyyetrzro/MF1X4JDgAEDU5opSBNIc2Qt7BOi2h0lGJpJS
         j8CM2cl2xIhAyijr5/xoX8NlrXlpAeSzAksLa1dsphDIYLdXeQCKx72wdlEKVO7fa4bG
         bNIA==
X-Gm-Message-State: AOAM532Bdz3+JRHqofWURYQFQrPe1k/sVndFhV1qF3t77+NUU55fydv4
	XI87fCw6cCQJ73JezstxjexUXw==
X-Google-Smtp-Source: ABdhPJzhTUxr8xtElyOo2sGLLBM/SHQIPL7qbearL3PQEkxev8oiF1oDVJM+cInZoueV8pCU8aX6hQ==
X-Received: by 2002:aa7:99c4:0:b029:1f6:c0bf:43d1 with SMTP id v4-20020aa799c40000b02901f6c0bf43d1mr10042556pfi.37.1616177023839;
        Fri, 19 Mar 2021 11:03:43 -0700 (PDT)
Date: Fri, 19 Mar 2021 11:03:42 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 12/12] landlock: Add user and kernel documentation
Message-ID: <202103191056.71AB0515A@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-13-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-13-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:52PM +0100, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> This documentation can be built with the Sphinx framework.

Well, yes. :) Maybe describe what the documentation covers instead here.
Regardless: yay docs! This is great.

> [...]
> +Bind mounts and OverlayFS
> +-------------------------
> +
> +Landlock enables to restrict access to file hierarchies, which means that these
> +access rights can be propagated with bind mounts (cf.
> +:doc:`/filesystems/sharedsubtree`) but not with :doc:`/filesystems/overlayfs`.
> +
> +A bind mount mirrors a source file hierarchy to a destination.  The destination
> +hierarchy is then composed of the exact same files, on which Landlock rules can
> +be tied, either via the source or the destination path.  These rules restrict
> +access when they are encountered on a path, which means that they can restrict
> +access to multiple file hierarchies at the same time, whether these hierarchies
> +are the result of bind mounts or not.
> +
> +An OverlayFS mount point consists of upper and lower layers.  These layers are
> +combined in a merge directory, result of the mount point.  This merge hierarchy
> +may include files from the upper and lower layers, but modifications performed
> +on the merge hierarchy only reflects on the upper layer.  From a Landlock
> +policy point of view, each OverlayFS layers and merge hierarchies are
> +standalone and contains their own set of files and directories, which is
> +different from bind mounts.  A policy restricting an OverlayFS layer will not
> +restrict the resulted merged hierarchy, and vice versa.

Can you include some examples about what a user of landlock should do?
i.e. what are some examples of unexpected results when trying to write
policy that runs on top of overlayfs, etc?

> [...]
> +File renaming and linking
> +-------------------------
> +
> +Because Landlock targets unprivileged access controls, it is needed to properly
> +handle composition of rules.  Such property also implies rules nesting.
> +Properly handling multiple layers of ruleset, each one of them able to restrict
> +access to files, also implies to inherit the ruleset restrictions from a parent
> +to its hierarchy.  Because files are identified and restricted by their
> +hierarchy, moving or linking a file from one directory to another implies to
> +propagate the hierarchy constraints.  To protect against privilege escalations
> +through renaming or linking, and for the sack of simplicity, Landlock currently

typo: sack -> sake

> [...]
> +Special filesystems
> +-------------------
> +
> +Access to regular files and directories can be restricted by Landlock,
> +according to the handled accesses of a ruleset.  However, files that do not
> +come from a user-visible filesystem (e.g. pipe, socket), but can still be
> +accessed through /proc/self/fd/, cannot currently be restricted.  Likewise,
> +some special kernel filesystems such as nsfs, which can be accessed through
> +/proc/self/ns/, cannot currently be restricted.  For now, these kind of special
> +paths are then always allowed.  Future Landlock evolutions will enable to
> +restrict such paths with dedicated ruleset flags.

With this series, can /proc (at the top level) be blocked? (i.e. can a
landlock user avoid the weirdness by making /proc/$pid/ unavailable?)

> +Ruleset layers
> +--------------
> +
> +There is a limit of 64 layers of stacked rulesets.  This can be an issue for a
> +task willing to enforce a new ruleset in complement to its 64 inherited
> +rulesets.  Once this limit is reached, sys_landlock_restrict_self() returns
> +E2BIG.  It is then strongly suggested to carefully build rulesets once in the
> +life of a thread, especially for applications able to launch other applications
> +that may also want to sandbox themselves (e.g. shells, container managers,
> +etc.).

How was this value (64) chosen?

-- 
Kees Cook
