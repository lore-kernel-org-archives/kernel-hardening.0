Return-Path: <kernel-hardening-return-21706-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 5B8ABC00A8F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Oct 2023 14:15:04 +0000 (UTC)
Received: (qmail 11946 invoked by uid 550); 24 Oct 2023 14:14:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11907 invoked from network); 24 Oct 2023 14:14:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698156881; x=1698761681; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39/htCYRe9NbFxKs9p8poVgSHtomj8Bq5m3t+aseWC4=;
        b=OjKoO5tevTbbI5lWiot52lu1Rsrl3TTCLV32OcYdkrGwLkrSZcrx7/o7lWWa3bm39y
         Hw+6Y8Hl6jjdb7DhJazTRc7Ysf26gPk1QxtKodfefEEyCRy8E1o6R7AHtKYhipxWYhbC
         VvVVglAkq8vo5cRyEaz4An5B3tJv6H14sNdiUzkqLxWkqErF9iKXvH1bsNjlkb7a48RJ
         r0om7pWo8zLc17lXM4gj8igykc2BO+MYtaBqDqmLI92kwKD1le6SGX3Tu6UzAyKfZqsm
         NEzntDngbCm6lIYLJaY4halE5cA/VNSkX/YlQnMCZ6OrC909KIwWeySpEKbrMHhhvqfB
         71qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698156881; x=1698761681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39/htCYRe9NbFxKs9p8poVgSHtomj8Bq5m3t+aseWC4=;
        b=HFk5TdNizwzpwq7RzwjvYVY4tuAZFh+UTCZkThDCY45QEBHhyL3ui5hl3PtK6bMwVf
         s3joeVcTC8UeDiYET5kdMMMLP8biZnkC7uKKEMLJOtzORH2UAOCbU5OprCFXMqRji8a2
         tnpfcxevBwIopZnmPH9Sby4EiKa7lKCqluxcFZ+jVmJBIq3PhgWoB9UIhe28kU8nirxm
         w2LD2MzrFbqGzKBJ/v+r+06emxY0iVI1qD8pBn5Z8S9UNyFuLv9J7gluGlxo/VL96pF6
         AfhitkVbLuRrkSaDDSDxO0KFO5ggPz7lJoJGELtSLmwOmWe5ps6NAi85w1ty5ZjQC/DB
         oYzw==
X-Gm-Message-State: AOJu0YzoKOsrKvkAfcPdOS8xXk9Euz/UU5qtSic72Bcff1Map7YIteCx
	fmpwN/7qADoF2aMAmWd7tzMwv1cEDupyDQPg27+6
X-Google-Smtp-Source: AGHT+IG7Qnk9seI+6+LHjRaeRYbFDoebTKWAzsyroymjLV7vFpq+o1Bd2VfrtuLgpKeqJg75LiSunq0fD8bfgi56tNY=
X-Received: by 2002:a25:ae67:0:b0:d9a:c7af:bb4d with SMTP id
 g39-20020a25ae67000000b00d9ac7afbb4dmr11126398ybe.37.1698156880636; Tue, 24
 Oct 2023 07:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <Y59qBh9rRDgsIHaj@mailbox.org> <20231024134608.GC320399@mail.hallyn.com>
In-Reply-To: <20231024134608.GC320399@mail.hallyn.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 24 Oct 2023 10:14:29 -0400
Message-ID: <CAHC9VhRCJfBRu8172=5jF_gFhv2znQXTnGs_c_ae1G3rk_Dc-g@mail.gmail.com>
Subject: Re: Isolating abstract sockets
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stefan Bavendiek <stefan.bavendiek@mailbox.org>, kernel-hardening@lists.openwall.com, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 9:46=E2=80=AFAM Serge E. Hallyn <serge@hallyn.com> =
wrote:
> On Sun, Dec 18, 2022 at 08:29:10PM +0100, Stefan Bavendiek wrote:
> > When building userspace application sandboxes, one issue that does not =
seem trivial to solve is the isolation of abstract sockets.
>
> Veeery late reply.  Have you had any productive discussions about this in
> other threads or venues?
>
> > While most IPC mechanism can be isolated by mechanisms like mount names=
paces, abstract sockets are part of the network namespace.
> > It is possible to isolate abstract sockets by using a new network names=
pace, however, unprivileged processes can only create a new empty network n=
amespace, which removes network access as well and makes this useless for n=
etwork clients.
> >
> > Same linux sandbox projects try to solve this by bridging the existing =
network interfaces into the new namespace or use something like slirp4netns=
 to archive this, but this does not look like an ideal solution to this pro=
blem, especially since sandboxing should reduce the kernel attack surface w=
ithout introducing more complexity.
> >
> > Aside from containers using namespaces, sandbox implementations based o=
n seccomp and landlock would also run into the same problem, since landlock=
 only provides file system isolation and seccomp cannot filter the path arg=
ument and therefore it can only be used to block new unix domain socket con=
nections completely.
> >
> > Currently there does not seem to be any way to disable network namespac=
es in the kernel without also disabling unix domain sockets.
> >
> > The question is how to solve the issue of abstract socket isolation in =
a clean and efficient way, possibly even without namespaces.
> > What would be the ideal way to implement a mechanism to disable abstrac=
t sockets either globally or even better, in the context of a process.
> > And would such a patch have a realistic chance to make it into the kern=
el?
>
> Disabling them altogether would break lots of things depending on them,
> like X :)  (@/tmp/.X11-unix/X0).  The other path is to reconsider network
> namespaces.  There are several directions this could lead.  For one, as
> Dinesh Subhraveti often points out, the current "network" namespace is
> really a network device namespace.  If we instead namespace at the
> bind/connect/etc calls, we end up with much different abilities.

The LSM layer supports access controls on abstract sockets, with at
least two (AppArmor, SELinux) providing abstract socket access
controls, other LSMs may provide controls as well.

--=20
paul-moore.com
