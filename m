Return-Path: <SRS0=diu1=IO=lists.openwall.com=kernel-hardening-return-20955-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC56C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:32:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D6AE64E07
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D6AE64E07
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20955-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1625 invoked by uid 550); 16 Mar 2021 19:32:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1605 invoked from network); 16 Mar 2021 19:32:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=785OaxI1+asEokVAhJYel0XTVJCjRIlanfaE3sEk6NA=;
        b=YML5LJOi/F1KCfVmVt+vteVo9RZ0Nf4OfZSU78l6Yo7zVYJNXY4kDB0R9sp6dSuVGv
         wwG+M9YEHq6hIKnJ+OZf0V/jL0U0+6oEp4dvZISrHGz0VD85aaegQQ0e51E5TkIXwh1w
         wOrmoK69CB+I15nBsASOeEHTZZcqf43NuyBmzXchlmia61al84mOrYBSPlOPaTyxnGPU
         PrWfKqddx443z87DJmQ6SIaI0f8dtpRF1nV2c2L7ioUSzmmgzBnNaK4grKubI3YUfxo6
         qHPjVxbHT1hlE5vAeBqUYJ8nh9hVw1NoR2g9WafVuEz/7KbpyRhGrI4M53SGQGFJW59E
         xiRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=785OaxI1+asEokVAhJYel0XTVJCjRIlanfaE3sEk6NA=;
        b=GAD30rd2cgA4Ftv9OwCkS8FSR0lNbL9v6ZIkHIRhBzf6jPM9/Uqgg3BtPcXzbwdxvt
         0d5n7aP/pxOvdN1yUNLnlK427WOhh9U4+zYPWg5iECaXT5obL+Xz8iNN8gWI4p+Gcbn7
         i/E8dn+XZPer588J6E7WJRwTRBHbsXQy2nxVEj9Eu0ypf8n12DMZHZCrjsq+QwyUNpQ+
         RHgI1CduO255r02+XgluvEd8ZmnB9pSeqeEKMiSWnH7mmqT7KD4i9p26c2qFivps+uX0
         NwqVj748Jjv6/9Gsu4IUmrlhvGlcXShR/uKDYhshwayqNitwmAH1HfnQor4itCyOd2Rk
         nKag==
X-Gm-Message-State: AOAM532wyLAw7BfOVDN9jvQ7rsIRV9C6Nsyq6IqkpaZ7auUO7ccpnfJB
	E+KnLj3xbU8SOJl7rzFYjkNbYBKeKp6HY1tpcAUFvA==
X-Google-Smtp-Source: ABdhPJyUyx1q4KJMLoOhWYhlwjjvjjgRSpoIaPQeL0ZmUDwgR/6ouMp1g0XUOQ8/ryX03IlqhblGhBWKjRnDnx3DdeE=
X-Received: by 2002:a2e:b6d4:: with SMTP id m20mr157623ljo.448.1615923142605;
 Tue, 16 Mar 2021 12:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210316170135.226381-1-mic@digikod.net> <20210316170135.226381-2-mic@digikod.net>
 <CAG48ez3=M-5WT73HqmFJr6UHwO0+2FJXxcAgRzp6wcd0P3TN=Q@mail.gmail.com> <ec7a3a21-c402-c153-a932-ce4a40edadaa@digikod.net>
In-Reply-To: <ec7a3a21-c402-c153-a932-ce4a40edadaa@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Tue, 16 Mar 2021 20:31:56 +0100
Message-ID: <CAG48ez0UHP=B6MW5ySMOAQ677byzyWkwgPto1RdW6FYJH5b7Zg@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] fs: Allow no_new_privs tasks to call chroot(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Brauner <christian.brauner@ubuntu.com>, 
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	Dominik Brodowski <linux@dominikbrodowski.net>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	John Johansen <john.johansen@canonical.com>, Kees Cook <keescook@chromium.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 16, 2021 at 8:26 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> On 16/03/2021 20:04, Jann Horn wrote:
> > On Tue, Mar 16, 2021 at 6:02 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.n=
et> wrote:
> >> One could argue that chroot(2) is useless without a properly populated
> >> root hierarchy (i.e. without /dev and /proc).  However, there are
> >> multiple use cases that don't require the chrooting process to create
> >> file hierarchies with special files nor mount points, e.g.:
> >> * A process sandboxing itself, once all its libraries are loaded, may
> >>   not need files other than regular files, or even no file at all.
> >> * Some pre-populated root hierarchies could be used to chroot into,
> >>   provided for instance by development environments or tailored
> >>   distributions.
> >> * Processes executed in a chroot may not require access to these speci=
al
> >>   files (e.g. with minimal runtimes, or by emulating some special file=
s
> >>   with a LD_PRELOADed library or seccomp).
> >>
> >> Unprivileged chroot is especially interesting for userspace developers
> >> wishing to harden their applications.  For instance, chroot(2) and Yam=
a
> >> enable to build a capability-based security (i.e. remove filesystem
> >> ambient accesses) by calling chroot/chdir with an empty directory and
> >> accessing data through dedicated file descriptors obtained with
> >> openat2(2) and RESOLVE_BENEATH/RESOLVE_IN_ROOT/RESOLVE_NO_MAGICLINKS.
> >
> > I don't entirely understand. Are you writing this with the assumption
> > that a future change will make it possible to set these RESOLVE flags
> > process-wide, or something like that?
>
> No, this scenario is for applications willing to sandbox themselves and
> only use the FDs to access legitimate data.

But if you're chrooted to /proc/self/fdinfo and have an fd to some
directory - let's say /home/user/Downloads - there is nothing that
ensures that you only use that fd with RESOLVE_BENEATH, right? If the
application is compromised, it can do something like openat(fd,
"../.bashrc", O_RDWR), right? Or am I missing something?

> > As long as that doesn't exist, I think that to make this safe, you'd
> > have to do something like the following - let a child process set up a
> > new mount namespace for you, and then chroot() into that namespace's
> > root:
> >
> > struct shared_data {
> >   int root_fd;
> > };
> > int helper_fn(void *args) {
> >   struct shared_data *shared =3D args;
> >   mount("none", "/tmp", "tmpfs", MS_NOSUID|MS_NODEV, "");
> >   mkdir("/tmp/old_root", 0700);
> >   pivot_root("/tmp", "/tmp/old_root");
> >   umount("/tmp/old_root", "");
> >   shared->root_fd =3D open("/", O_PATH);
> > }
> > void setup_chroot() {
> >   struct shared_data shared =3D {};
> >   prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
> >   clone(helper_fn, my_stack,
> > CLONE_VFORK|CLONE_VM|CLONE_FILES|CLONE_NEWUSER|CLONE_NEWNS|SIGCHLD,
> > NULL);
> >   fchdir(shared.root_fd);
> >   chroot(".");
> > }
>
> What about this?
> chdir("/proc/self/fdinfo");
> chroot(".");
> close(all unnecessary FDs);

That breaks down if you can e.g. get a unix domain socket connected to
a process in a different chroot, right? Isn't that a bit too fragile?
