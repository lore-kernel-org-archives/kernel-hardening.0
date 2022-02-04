Return-Path: <kernel-hardening-return-21541-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9F0B9C433F5
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Feb 2022 12:04:39 +0000 (UTC)
Received: (qmail 7485 invoked by uid 550); 4 Feb 2022 12:04:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17622 invoked from network); 4 Feb 2022 09:45:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1643967921;
	bh=Mb1R1CEJLIUyU5wYRD8/Qpqu3jJJ3pUvR4P+L2WzG/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VdXT7cfXmWgRTGFrFK4UYDPtnMEiXnlrLID8e4DhBOmtkMoQoR1WrWRLjL6qE7/gy
	 Vkyfh3bMBU1+zJL5PfximPP4YzMgQgKH/rMGPEkHjVWhp3FcOTy0iRDMWkQwMLXdTa
	 FH4XnQFfBaba0OyF9OAof5Jf50zRKMQll7uoptUeIpZaA1ZKZ4b8U7u7sa1CPZ+28o
	 85G6lbAIBHg6N5y5pgXEIB+2YZORRMjC5ZuKQ+HluxrBRuI2FoHI2kzxpFjUBRrrHB
	 arxN5jZ0BaWG2sS0dSQvWzyohvvvbF8NrHuS9e5sT80CLx1esKSjW8gVU5JeLOziPS
	 1XXWcXMno00GQ==
Date: Fri, 4 Feb 2022 10:45:15 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Anton V. Boyarshinov" <boyarsh@altlinux.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	ebiederm@xmission.com, legion@kernel.org, ldv@altlinux.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Add ability to disallow idmapped mounts
Message-ID: <20220204094515.6vvxhzcyemvrb2yy@wittgenstein>
References: <20220204065338.251469-1-boyarsh@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204065338.251469-1-boyarsh@altlinux.org>

On Fri, Feb 04, 2022 at 09:53:38AM +0300, Anton V. Boyarshinov wrote:
> Idmapped mounts may have security implications [1] and have
> no knobs to be disallowed at runtime or compile time.
> 
> This patch adds a sysctl and a config option to set its default value.
> 
> [1] https://lore.kernel.org/all/m18s7481xc.fsf@fess.ebiederm.org/
> 
> Based on work from Alexey Gladkov <legion@kernel.org>.
> 
> Signed-off-by: Anton V. Boyarshinov <boyarsh@altlinux.org>
> ---

Thank your for the general idea, Anton.

If you want to turn off idmapped mounts you can already do so today via:
echo 0 > /proc/sys/user/max_user_namespaces

Aside from that, idmapped mounts can only be created by fully privileged
users on the host for a selected number of filesystems. They can neither
be created as an unprivileged user nor can they be created inside user
namespaces.

I appreciate the worry. Any new feature may have security implications
and bugs. In addition, we did address these allegations multiple times
already (see [1], [2], [3], [4], [5]).

As the author/maintainer of this feature,
Nacked-by: Christian Brauner <brauner@kernel.org>

[1]: https://lore.kernel.org/lkml/20210213130042.828076-1-christian.brauner@ubuntu.com/T/#m3a9df31aa183e8797c70bc193040adfd601399ad
[2]: https://lore.kernel.org/lkml/m1r1ifzf8x.fsf@fess.ebiederm.org
[3]: https://lore.kernel.org/lkml/20210213130042.828076-1-christian.brauner@ubuntu.com/T/#m59cdad9630d5a279aeecd0c1f117115144bc15eb
[4]: https://lore.kernel.org/lkml/20210510125147.tkgeurcindldiwxg@wittgenstein
[5]: https://lore.kernel.org/linux-fsdevel/CAHrFyr4AYi_gad7LQ-cJ9Peg=Gt73Sded8k_ZHeRZz=faGzpQA@mail.gmail.com

