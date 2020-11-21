Return-Path: <SRS0=DJIr=E3=lists.openwall.com=kernel-hardening-return-20446-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E2FC63697
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 07:01:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1B9AF22226
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 07:01:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dyVl3+GK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B9AF22226
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20446-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1736 invoked by uid 550); 21 Nov 2020 07:00:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1668 invoked from network); 21 Nov 2020 07:00:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zCcA4sLycmShyMxZ6i9Eumf1OUB1JNsCrcUOdwj1SQI=;
        b=dyVl3+GKSo/xVNAFCoPUWUc6gQmdnw/aoaQ4OWYQZWi2kHziBvNSeTnr32XAufXgxx
         hKm1lXxIoBOeyloaPYvydgxjC+QYQhPhdTBvC3QDAyA7AJyAjx1Sfg+qUFcGGSyONF8a
         rMKz4vmvLjBUQoyU5nljmBLmfmujXCOPYrMhv1QkKNn3puxg8Bv8DNt5W2ZOwFPaeWbF
         Wzo6H7mzy9nAyHb2lga5U1+/aFxC+fqkiabeBSqjroyj0XzDF5MUiNTLKPowTk9qU32M
         0Frm4j8FEeopwqA7QqTNyauy419MUnrYWXvN0JzetsvpCro/b6d4UfZLXFRL8XQqSWR4
         iSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zCcA4sLycmShyMxZ6i9Eumf1OUB1JNsCrcUOdwj1SQI=;
        b=MAx+HGJw1ko+NcC/HddeXDQxlIk/DZ0zO+eVqJcXrAGH8UOFpHJ7oNfDp+wiCcW7b/
         bXeHjZ3tJxfZrM1/OjLKCGG7JMwZfk4cIuTnXKra2IlbQz0WnBG7pMXE2+GQ7zzi83p8
         99D/CjR4iZlla+PxLNxg1Tm2m0lt7fmBwLrrol2SOcSp+vCoXJi4xJDufj53iSEGzBZO
         yspMfJyaYEAq3yIqwYHrdr+uZv5SnPLQUBXYPVpEMi1R9psN914kG6xvSXRwOkLQ5Xew
         KIeb/slSyL7i1xu0qRkEBDL4UBxrDznomtS/bUcyFeJpV1pQZfCLbCefVJObdXh1NIwC
         p93w==
X-Gm-Message-State: AOAM533EZdT9RTyG2McpnIAwP32cWSe1hH5u5RpXg/Rbh12yR9jqCjb9
	n920MJNnlZORArx3V4A9d0GfTzEdnvJf1QcZ0ubBcA==
X-Google-Smtp-Source: ABdhPJy8wln+obg/cf+h2tvCfZva23mNjQ3IqbWTfUAeh0QB4VP+04PcFgpYrhykI0RBGORAa7WxIWYKQRHp7mANu3Y=
X-Received: by 2002:a2e:9d8d:: with SMTP id c13mr9054289ljj.160.1605942047455;
 Fri, 20 Nov 2020 23:00:47 -0800 (PST)
MIME-Version: 1.0
References: <20201112205141.775752-1-mic@digikod.net> <20201112205141.775752-8-mic@digikod.net>
In-Reply-To: <20201112205141.775752-8-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Sat, 21 Nov 2020 08:00:00 +0100
Message-ID: <CAG48ez3HA63CX852LLDFCcNyzRGwAr3x_cvA1-t8tgDxfF1dOQ@mail.gmail.com>
Subject: Re: [PATCH v24 07/12] landlock: Support filesystem access-control
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

On Thu, Nov 12, 2020 at 9:52 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> Thanks to the Landlock objects and ruleset, it is possible to identify
> inodes according to a process's domain.  To enable an unprivileged
> process to express a file hierarchy, it first needs to open a directory
> (or a file) and pass this file descriptor to the kernel through
> landlock_add_rule(2).  When checking if a file access request is
> allowed, we walk from the requested dentry to the real root, following
> the different mount layers.  The access to each "tagged" inodes are
> collected according to their rule layer level, and ANDed to create
> access to the requested file hierarchy.  This makes possible to identify
> a lot of files without tagging every inodes nor modifying the
> filesystem, while still following the view and understanding the user
> has from the filesystem.
>
> Add a new ARCH_EPHEMERAL_INODES for UML because it currently does not
> keep the same struct inodes for the same inodes whereas these inodes are
> in use.
>
> This commit adds a minimal set of supported filesystem access-control
> which doesn't enable to restrict all file-related actions.  This is the
> result of multiple discussions to minimize the code of Landlock to ease
> review.  Thanks to the Landlock design, extending this access-control
> without breaking user space will not be a problem.  Moreover, seccomp
> filters can be used to restrict the use of syscall families which may
> not be currently handled by Landlock.
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> ---
>
> Changes since v23:
> * Enforce deterministic interleaved path rules.  To have consistent
>   layered rules, granting access to a path implies that all accesses
>   tied to inodes, from the requested file to the real root, must be
>   checked.  Otherwise, stacked rules may result to overzealous
>   restrictions.  By excluding the ability to add exceptions in the same
>   layer (e.g. /a allowed, /a/b denied, and /a/b/c allowed), we get
>   deterministic interleaved path rules.  This removes an optimization

I don't understand the "deterministic interleaved path rules" part.


What if I have a policy like this?

/home/user READ
/home/user/Downloads READ+WRITE

That's a reasonable policy, right?

If I then try to open /home/user/Downloads/foo in WRITE mode, the loop
will first check against the READ+WRITE rule for /home/user, that
check will pass, and then it will check against the READ rule for /,
which will deny the access, right? That seems bad.


The v22 code ensured that for each layer, the most specific rule (the
first we encounter on the walk) always wins, right? What's the problem
with that?

>   which could be replaced by a proper cache mechanism.  This also
>   further simplifies and explain check_access_path_continue().

From the interdiff between v23 and v24 (git range-diff
99ade5d59b23~1..99ade5d59b23 faa8c09be9fd~1..faa8c09be9fd):

    @@ security/landlock/fs.c (new)
     +                  rcu_dereference(landlock_inode(inode)->object));
     +  rcu_read_unlock();
     +
    -+  /* Checks for matching layers. */
    -+  if (rule && (rule->layers | *layer_mask)) {
    -+          if ((rule->access & access_request) =3D=3D access_request) =
{
    -+                  *layer_mask &=3D ~rule->layers;
    -+                  return true;
    -+          } else {
    -+                  return false;
    -+          }
    ++  if (!rule)
    ++          /* Continues to walk if there is no rule for this inode. */
    ++          return true;
    ++  /*
    ++   * We must check all layers for each inode because we may encounter
    ++   * multiple different accesses from the same layer in a walk.  Each
    ++   * layer must at least allow the access request one time (i.e. with=
 one
    ++   * inode).  This enables to have a deterministic behavior whatever
    ++   * inode is tagged within interleaved layers.
    ++   */
    ++  if ((rule->access & access_request) =3D=3D access_request) {
    ++          /* Validates layers for which all accesses are allowed. */
    ++          *layer_mask &=3D ~rule->layers;
    ++          /* Continues to walk until all layers are validated. */
    ++          return true;
     +  }
    -+  return true;
    ++  /* Stops if a rule in the path don't allow all requested access. */
    ++  return false;
     +}
     +
     +static int check_access_path(const struct landlock_ruleset *const dom=
ain,
    @@ security/landlock/fs.c (new)
     +                          &layer_mask)) {
     +          struct dentry *parent_dentry;
     +
    -+          /* Stops when a rule from each layer granted access. */
    -+          if (layer_mask =3D=3D 0) {
    -+                  allowed =3D true;
    -+                  break;
    -+          }
    -+

This change also made it so that disconnected paths aren't accessible
unless they're internal, right? While previously, the access could be
permitted if the walk stops before reaching the disconnected point? I
guess that's fine, but it should probably be documented.

     +jump_up:
     +          /*
     +           * Does not work with orphaned/private mounts like overlayf=
s
    @@ security/landlock/fs.c (new)
     +                          goto jump_up;
     +                  } else {
     +                          /*
    -+                           * Stops at the real root.  Denies access
    -+                           * because not all layers have granted acce=
ss.
    ++                           * Stops at the real root.  Denies access i=
f
    ++                           * not all layers granted access.
     +                           */
    -+                          allowed =3D false;
    ++                          allowed =3D (layer_mask =3D=3D 0);
     +                          break;
     +                  }
     +          }
