Return-Path: <SRS0=1X9J=7M=lists.openwall.com=kernel-hardening-return-18904-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8838BC433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:35:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CDD37206C3
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="M1w7QJEM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDD37206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18904-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27992 invoked by uid 550); 30 May 2020 14:35:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27960 invoked from network); 30 May 2020 14:35:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590849291;
	bh=siAvfo9HnN3isuQwfk3oJJG9pEuKrhYtdnBCMJBsSw8=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=M1w7QJEMonxRcLWIRS5LPxtSjbKzGrj0kwEqw7ebgZ6TGEOQEwxX35owgO5DmjR0z
	 iD3sk+Ju6q0YkNB94DBLRSQYevtRo56tA2ntq+hO746JsTXUGHbrWBd5gNiTgDQ/DQ
	 IarT5bgGLpae4G+IV2CClgDSBaD36Gp7/zDMj5Qk=
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
Subject: [PATCH v5 0/3] drivers/acpi: Remove function callback casts
Date: Sat, 30 May 2020 16:34:27 +0200
Message-Id: <20200530143430.5203-1-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TLH3I1kZ/4RoCLR609cAd5CkkvREkPM2JAq81g5rMkxNaLQnDQ+
 En+YRkX25Sn2scR2EVv6z5wE/Wqon57mocitz3KWRvI61P0+897D+c487MqOudRehaHpO6w
 EL32gX+ACur+ObiMvftdM6jr0m9YEmwXeB6QQcOkuJ+kxHCHOVMeTLtR/yCqXK3g5qX43Eq
 gTzTOfhazuiUiisqJMQ9g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:e+hkXNAahyQ=:X7kgqKeMlUO7T2y1y3UVSg
 HsQ4CiOn5htqFKTWGiWZHjajnGv2XzPqVhyj2J0ApZ/OIrwmJPmZXvYEWfSTEgdERdUTBS3Fo
 OmyzGSbvHtd6nuGLvrWrLkH8vnygJcxVp5lVtkiZIo10Qn/6pdQa9+fPcA5OJ+6HmdHCstAlB
 bn3b7J3uPn4hnmiJOYCP+R+tIf/l51cu7tqTFzJxetAVzeHWoFQsNSnUmSwLtm8Xy6YrRsCKs
 wlCjpAJls1/JP+m+t/PMdw6zfEh2DLxAgeGYhK3a1y+Y4vELOrAeFAnSOlVKjUC3XMZwfQLqJ
 lQHyQ1nAkmZcdJzj98oq+RVpxBSFGPCHzc8H7By+SguMbfycHLfKp1o73t/uKxcdbybl9U4DB
 izL8A9I7PNKtIFiGRWL75BLFONH2y/5CPjz6NB9Qv14OrQFFss9tvKk8a78puSyCWibthicxI
 uamTBTTk4x6p6ikqi1SSopgtAz0s8fSUViSwX0WQR189IOKp2StD8JLAAawAgSWzgYlznrbY6
 pOvBjys5Idl96AuUTNRpKzzu2l1zJQNld1Yevy+R6bejuku+HQRLeintgxePdF7Wb7XL6cyWF
 ec/kRzWhwNJGEf1zkDRIaQ1+LQpPCXUfeBIARQOIm3zV22Wv6jLeX4cua1vo30KXwakALrM38
 X3H0DtVFSIfUr8PiHmNFy4GHgN2aAG8mdOSxumDfMJPqG0sCuPQ+jTJsHD8ITmQrP+Xgvvyl/
 3BZRM7gP3H0N8uVfptJj1q2JcojXeTsLAzqwvsxccVhU5msxURrDWdXSgeI13wINiVuTB9KKB
 gW7V+9/NNUFx0DwpKHQQrFZZk2Cr+QxgJvpvArJRSZniyoww3Jutq/r4Ot4Lx2LSUomoAfPvM
 e2gy8/kITYWDPevJZDEtBh/fwT3RTfF7Owfb+qCodfo5yeQ9tDMUio6OtLDzWOqRTQEBtzqFC
 2m1iKvxUH2cForraIjk+g81gkrG4LJH7PPzWE0kVm3fhTxfZr3ixI+mmsj+XEXu+c8ta9FSSp
 WegeLWI5XGGBM2S84CRoztGmhwmx0hnpihw4Qwk/8AdyLeNlxvsBO+ZQ9BZHfR6pFkMb9Y4fG
 geSgfEOvmrKNvEeqTvlpUcsemzFdcbkcZzBTfBS+ZKUGyYDqfRDpMKVDhuu/6oUKgl5cihHb6
 ECSIErVUbGPZNsBJ+toGdqYR3kMFgz3rndXcRJFC3otpiqa0piUxPWaGsCcLgTxtqjCpj7cJN
 PKBNQp+AFYV7256XR

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
  Co-developed-by: Marc Zyngier <maz@kernel.org>
  Signed-off-by: Marc Zyngier <maz@kernel.org>

Changelog v3->v4
- Add a new patch to remove the cast of the macro
  ACPI_DECLARE_PROBE_ENTRY (Marc Zyngier)
- Change the subject of the first patch

Changelog v4->v5
- Add the following lines removed by error in the v4 version:
  Co-developed-by: Marc Zyngier <maz@kernel.org>
  Signed-off-by: Marc Zyngier <maz@kernel.org>

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

