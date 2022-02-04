Return-Path: <kernel-hardening-return-21542-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2F99AC433F5
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Feb 2022 12:04:47 +0000 (UTC)
Received: (qmail 7821 invoked by uid 550); 4 Feb 2022 12:04:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30309 invoked from network); 4 Feb 2022 10:26:28 -0000
Date: Fri, 4 Feb 2022 13:26:16 +0300
From: "Anton V. Boyarshinov" <boyarsh@altlinux.org>
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
 ebiederm@xmission.com, legion@kernel.org, ldv@altlinux.org,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 Christoph Hellwig <hch@lst.de>, Linus Torvalds
 <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Add ability to disallow idmapped mounts
Message-ID: <20220204132616.28de9c4a@tower>
In-Reply-To: <20220204094515.6vvxhzcyemvrb2yy@wittgenstein>
References: <20220204065338.251469-1-boyarsh@altlinux.org>
	<20220204094515.6vvxhzcyemvrb2yy@wittgenstein>
Organization: ALT Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-alt-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 4 Feb 2022 10:45:15 +0100
Christian Brauner <brauner@kernel.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> If you want to turn off idmapped mounts you can already do so today via:
> echo 0 > /proc/sys/user/max_user_namespaces

It turns off much more than idmapped mounts only. More fine grained
control seems better for me.

> They can neither
> be created as an unprivileged user nor can they be created inside user
> namespaces.

But actions of fully privileged user can open non-obvious ways to
privilege escalation.
