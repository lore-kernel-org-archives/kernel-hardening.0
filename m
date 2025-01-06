Return-Path: <kernel-hardening-return-21916-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id C1945E77188
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jan 2025 00:19:04 +0000 (UTC)
Received: (qmail 21609 invoked by uid 550); 7 Jan 2025 00:18:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13789 invoked from network); 6 Jan 2025 23:49:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736207358;
	bh=AKDblFyGSXFHnQiBgrRD0Gxn72X5JIg7RBip/sLYtvk=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=K1f3sK5nKW1Evn2VbiakpExEBZdVGYklt02ihKSbRUOYdxm6K+yCTotn3WVum1xfN
	 Z+VVE4nQjD/H1BPkZ8uvq0IZ9uz1tTHhiKkQRaJ9Qg7jzbubeItrY2pEN+LtJzIFEM
	 rl24Ec9F0pYpU+v+nlFXchIGlyNuOg4mxaoGdJNDOgJIfVgNcTNST48TmCAkj1zxj/
	 6qP/WrbdViepMm1TNG4Cm3vCy/37B8uahTUX9TcHEU0xHnrz3gUdgaD+Jo7BXkRClH
	 Ou3e0s7cMM3MEgqRbLwDZmTROfycfVI3H9g6G4twXN8kIU6eLw81RIOYfmQ8zf/1lj
	 a+/A8n5s+5WUg==
Message-ID: <5cfc565e175bdc5b37dc875bf8ee3076.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <xfjn4wqrhukvi45dkgkbulamq3242eijn7567vxwaxznh4ebdr@waat7u3l2mhi>
References: <xfjn4wqrhukvi45dkgkbulamq3242eijn7567vxwaxznh4ebdr@waat7u3l2mhi>
Subject: Re: [PATCH] clk: ti: use kcalloc() instead of kzalloc()
From: Stephen Boyd <sboyd@kernel.org>
Cc: mturquette@baylibre.com, linux-omap@vger.kernel.org, linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
To: Ethan Carter Edwards <ethan@ethancedwards.com>, kristo@kernel.org
Date: Mon, 06 Jan 2025 15:49:15 -0800
User-Agent: alot/0.12.dev1+gaa8c22fdeedb

Quoting Ethan Carter Edwards (2024-12-29 21:28:58)
> Use 2-factor multiplication argument form kcalloc() instead
> of kzalloc().
>=20
> Link: https://github.com/KSPP/linux/issues/162
>=20
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> ---

Applied to clk-next
