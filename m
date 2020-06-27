Return-Path: <SRS0=mJ0z=AI=lists.openwall.com=kernel-hardening-return-19181-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E4FC433E1
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jun 2020 11:08:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D04DA215A4
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jun 2020 11:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGldGMH4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D04DA215A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19181-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1053 invoked by uid 550); 27 Jun 2020 11:08:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32763 invoked from network); 27 Jun 2020 11:08:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593256105;
	bh=CKFRZQvVXoQGRUt/fr1evMIOtF/D2G3jbib+jYbyxlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGldGMH4GnVEZJM9lKrAO4vuHndpGt+hjl6cH5CtcHpuSHOS89YEYTeMdXj+1PQKX
	 IpFUxwH79KoWlnNgFGOfWbPavxAZkbyeSsGtIo3zhpECkuamaVI9UYUJyQ3WNJjsiF
	 4keML4Szu08xHn+uJV7hdRQ1XL2Ht1/vYL+oTEMY=
From: Marc Zyngier <maz@kernel.org>
To: Jason Cooper <jason@lakedaemon.net>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Thomas Gleixner <tglx@linutronix.de>,
	Oscar Carter <oscar.carter@gmx.com>,
	Kees Cook <keescook@chromium.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <lenb@kernel.org>
Cc: Andrew Perepech <andrew.perepech@mediatek.com>,
	linux-mediatek@lists.infradead.org,
	Stephane Le Provost <stephane.leprovost@mediatek.com>,
	linux-arm-kernel@lists.infradead.org,
	Pedro Tsai <pedro.tsai@mediatek.com>,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Fabien Parent <fparent@baylibre.com>,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 0/3] drivers/acpi: Remove function callback casts
Date: Sat, 27 Jun 2020 12:08:05 +0100
Message-Id: <159325548742.93134.13767620418777913420.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200530143430.5203-1-oscar.carter@gmx.com>
References: <20200530143430.5203-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: jason@lakedaemon.net, matthias.bgg@gmail.com, brgl@bgdev.pl, tglx@linutronix.de, oscar.carter@gmx.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, andrew.perepech@mediatek.com, linux-mediatek@lists.infradead.org, stephane.leprovost@mediatek.com, linux-arm-kernel@lists.infradead.org, pedro.tsai@mediatek.com, bgolaszewski@baylibre.com, fparent@baylibre.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-acpi@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 30 May 2020 16:34:27 +0200, Oscar Carter wrote:
> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, there are the need to remove all
> the function callback casts in the acpi driver.
> 
> The first patch creates a macro called ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
> to initialize the acpi_probe_entry struct using the probe_subtbl field
> instead of the probe_table field to avoid function cast mismatches.
> 
> [...]

Applied to irq/irqchip-5.9:

[1/3] drivers/acpi: Add new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
      commit: 89778093d38d547cd80f6097659d1cf1c2dd4d9d
[2/3] drivers/irqchip: Use new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
      commit: aba3c7ed3fcf74524b7072615028827d5e5750d7
[3/3] drivers/acpi: Remove function cast
      commit: 8ebf642f3d809b59f57d0d408189a2218294e269

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.

