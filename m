Return-Path: <kernel-hardening-return-21549-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id C84E5C433EF
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Mar 2022 11:44:26 +0000 (UTC)
Received: (qmail 10086 invoked by uid 550); 18 Mar 2022 11:41:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22040 invoked from network); 18 Mar 2022 00:01:23 -0000
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VZ8vdPsd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1647561669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=uwfZ7u+3OUKgL2+/D4viVTjD3L/cggI1cxQSeUBNcqU=;
	b=VZ8vdPsdW4WvfTWCZPkBuyeVynesqYbTOhZu8YXFilIQFZHmQnyrK/rvBX/GiAGi5P/J73
	+IMgJeR4h82Oh6ro7VPXVvu/4ef3gBo7fODxmqqKrgzIiM3K9euepRanv+tC8At3oq+mjB
	88QCgJ9p98VBW7gKkeCnGYAJpqkfXHE=
X-Gm-Message-State: AOAM533fTTrvnnNBSMy17dr925gENycjS4x5haJAIBi+rgpKyK+90dFp
	2bM9i4DfU5VQW/PNQRZQnkwkTSNNTAddFvDS3Ts=
X-Google-Smtp-Source: ABdhPJwVWHzVA9/oVu+v9YAWochheu96zGoBfiL9ysWNAsJYRohB0h4ZM53akO0WYjRYXdttDZpJBVwPfJnO85MPGHc=
X-Received: by 2002:a0d:c681:0:b0:2db:9ffe:1f00 with SMTP id
 i123-20020a0dc681000000b002db9ffe1f00mr9121007ywd.100.1647561668026; Thu, 17
 Mar 2022 17:01:08 -0700 (PDT)
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 17 Mar 2022 18:00:57 -0600
X-Gmail-Original-Message-ID: <CAHmME9q55ifnzxE9zLuLT=Hgjv=qcvjU-O-c8G=_o_V_O+p44Q@mail.gmail.com>
Message-ID: <CAHmME9q55ifnzxE9zLuLT=Hgjv=qcvjU-O-c8G=_o_V_O+p44Q@mail.gmail.com>
Subject: Large post detailing recent Linux RNG improvements
To: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"

Hey folks,

Thought I should mention here that I've written up the various RNG
things I've been working on for 5.17 & 5.18 here:
https://www.zx2c4.com/projects/linux-rng-5.17-5.18/ .

Feel free to discuss on list here if you'd like, or if you see
something you don't like, I'll happily review patches!

Regards,
Jason
