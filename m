Return-Path: <SRS0=mVk7=7M=lists.openwall.com=kernel-hardening-return-18899-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAFDC433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 71DB320723
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="HoLdFZWV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71DB320723
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18899-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11271 invoked by uid 550); 30 May 2020 14:13:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10214 invoked from network); 30 May 2020 14:12:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590847967;
	bh=QrXSg+UsJWP9gK1C6YHtAzZxavSADYLznOMiGJYo0fM=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=HoLdFZWVARYEkZXY0/me61dcAuoRwrKz1NSBFVE1YYveqh6oO0YVzWRzHnvdww8Yy
	 htPuc0y2gICBAmFV2Sij79V7rsd/EgBdxnAEnO7n9gJ+paTa/ac0Y+r8DZLBMRLZSl
	 pzyTN6iZb26Gtjh3gW/++oFKbQ8CYdaWy5AzyecA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Cooper <jason@lakedaemon.net>,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <lenb@kernel.org>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: [PATCH v4 0/3] drivers/acpi: Remove function callback casts
Date: Sat, 30 May 2020 16:12:15 +0200
Message-Id: <20200530141218.4690-1-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MKwnw8vsgVAwEAVuWa65vsFSug6LsmUBtFRTQuX0nExrfiTk0dD
 LAgIwS6u5buJEAwX1/thqgEhZqMh78xDqhrn7TONBLWfbmdMLZCdnivpzlM5h72SeeT3ZKk
 ksOs8/ynSWaFPdFxi7RL3ZnHlYeb3fvQjXAu7FQIJ2T8wfgKE4mfcV/tLoz164Q2HKoyV+F
 asaKS/TLfp6CpenJkyAKQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZnBXQf3zzPs=:WNc8x7+IPX6FKsLCUyusxA
 cNqjWhONlAifoVAqd1jPrY/KDI5fyLupqrtwEzj0/bcrii1jovxCvEzo0V0Wp5qIXQwJRe3wt
 cRKsgzdDyRtgWBSiLGlaZHPQPBvnlAHxJd+gqL6DtzhpeZciUnlc0mfKkqp6JORNoOhp7izVV
 TcEgKpBlqc/2/7XZEwdT+UwsnjOxl0eg/8EzatLlZxjyw7whwSZUZ6jWfo+COYRVWQ1wbhLNY
 75kn8sQZbpYjJhmiDmDYuUzf2UQF40H/ZFLnm7cnleayCFYQq4ZjrEZzMYHTwpLdGhTQ7apAS
 Yzk3VklRUuFsJ83kWpz7nwNQ9Wq0HyNdGAjrcZkVHWi44mi7w2oUgbGUJrSsEAr0I++nTxhSt
 SnNcMKHE/ULRIiuYjkhCl+3ihwcw/8VvKqr1urK0pYA6ecjRolVAs2GXXKpoCxuad3DD5Inv+
 dkcLVAio0DG6wq5bXloOfXxktmkflQdIVB4jHqKXF6p07Z9uMNDM5v1eguQYizzR3zlsAt/3A
 vlA8EPGSSwFlybFXLXHax5p/OrOyqLACBj+Pq1jhz9hsYNzKytN7FOXBDABetbG5lMLpNVCKa
 9mVuVhQdEgSkwBF+ATImYD8cU9t2NHgHXUBX6cOapY0DQYC2+6Nl6Q6lA4IEa2bvSPOT8CoY5
 9MV2s3T0inxT4ePLjcZkCWxgYuT6eseDlxKRx1znIz44Q2emBvmiZD25t1kRrzFujAMbAzkuo
 dtb5rsbeD05N4ZDdWgMDIAWTj4OEYEWIVOAMIiQfwFE2PtJ6vOSWkNTej32Ll7kni2Y/zm1Ft
 4n9e1Ye7JUbkJybKugn9QnKGcnF3a80TSDKIfqlxzZADvfnf7wibHtNX7etPIDz9wrGyFRFVk
 AVZABgLOzRuIK3XdaF4k8eC+3wc9x3T1akE6bcR82SIeVCNsfTi/2waIyvjLzL71U4ncnevf4
 2b63kOOb678erZz6GqVzqg9C2WqKFiRAv71cWWhUICew6VkqXBPiPXR/Vj37sBC0kIBqlyqVq
 1w7SB7xkLD0uVuceRl0hYV60275/UjfAYOpUH2Nj9/+TtOhTuEX16KRX888Ge27SX/bjB1PnH
 BW+Nis/I/ObxVhEaCG1na0Rglt478FyKbNl6aOf80O3PhpQNP9zAM5MvGN2qzzIJJJGZC3Ob4
 u7mByRBf8FOK4tipjmzlCdNr1gvlwlAozjbCVpuzBaGP4eRxbmpZOIHSQWt/6CupZy3MQmGXz
 Hx+OiafBo0ua2gIpd

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, there are the need to remove all
the function callback casts in the acpi driver.

The first patch creates a macro called ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
to initialize the acpi_probe_entry struct using the probe_subtbl field
instead of the probe_table field to avoid function cast mismatches.

The second patch modifies the IRQCHIP_ACPI_DECLARE macro to use the new
defined macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY instead of the macro
ACPI_DECLARE_PROBE_ENTRY. Also, modifies the prototype of the functions
used by the invocation of the IRQCHIP_ACPI_DECLARE macro to match all the
parameters.

The third patch removes the function cast in the ACPI_DECLARE_PROBE_ENTRY
macro to ensure that the functions passed as a last parameter to this macr=
o
have the right prototype. This macro is used only in another macro
called "TIMER_ACPI_DECLARE". An this is used only in the file:

drivers/clocksource/arm_arch_timer.c

In this file, the function used in the last parameter of the
TIMER_ACPI_DECLARE macro already has the right prototype. So there is no
need to modify its prototype.

Changelog v1->v2
- Add more details in the commit changelog to clarify the changes (Marc
  Zyngier)
- Declare a new macro called ACPI_DECLARE_SUBTABLE_PROBE_ENTRY (Marc
  Zyngier)
- In the IRQCHIP_ACPI_DECLARE use the new defined macro (Marc Zyngier)

Changelog v2->v3
- Remove the cast of the macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY (Marc
  Zyngier)
- Change the prototype of the functions used by the invocation of the
  macro IRQCHIP_ACPI_DECLARE (Marc Zyngier)
- Split the changes in two patches.
- Add these two lines, to give credit to Marc Zyngier
  Signed-off-by: Marc Zyngier <maz@kernel.org>
  Signed-off-by: Oscar Carter <oscar.carter@gmx.com>

Changelog v3->v4
- Add a new patch to remove the cast of the macro
  ACPI_DECLARE_PROBE_ENTRY (Marc Zyngier)
- Change the subject of the first patch

Oscar Carter (3):
  drivers/acpi: Add new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
  drivers/irqchip: Use new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
  drivers/acpi: Remove function cast

 drivers/irqchip/irq-gic-v3.c |  2 +-
 drivers/irqchip/irq-gic.c    |  2 +-
 include/linux/acpi.h         | 23 +++++++++++++++++------
 include/linux/irqchip.h      |  5 +++--
 4 files changed, 22 insertions(+), 10 deletions(-)

=2D-
2.20.1

