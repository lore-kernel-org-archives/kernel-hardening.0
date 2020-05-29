Return-Path: <SRS0=oNca=7L=lists.openwall.com=kernel-hardening-return-18893-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AF5C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 May 2020 17:19:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA2372075A
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 May 2020 17:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="BshcmY9k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA2372075A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18893-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5715 invoked by uid 550); 29 May 2020 17:19:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5683 invoked from network); 29 May 2020 17:19:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590772753;
	bh=zkGJm1xLC+g8Ug4Cc2rYdtiWz2ihMopfD0re3TQO3z4=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=BshcmY9kRl14wxkX1Rf9nj6CDqOBwQ3P2TNTa1+cTSgzt+jESE9Dax4vX4aGW/dSV
	 6Ts0kXTohXxuE97Ds//ga+cLcMEY5H6gr33bOtbXtqsT2JM0LUZ5TWQBitn66YKbS2
	 7cS7HQ58pNB0RuJXzvPHQX+ewa38pDwKYjt08BFk=
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
Subject: [PATCH v3 0/2] drivers/irqchip: Remove function callback casts
Date: Fri, 29 May 2020 19:18:45 +0200
Message-Id: <20200529171847.10267-1-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3F47Cf3CCrsTEcrbYC/MIzrnF+WKS5gj28qusV2C+LXXadlg0ai
 +IEGA/UMqP92lxdUrLo89mgSiH18hwOyNf0VFwe9vveC5IZRsp3aYij0taCpo/qvAOJqP4U
 IwXDocxFDvqE+lAbQPC0rE1YjRLxvEmB9IedznwiL9YL+7cwTerlljoQ0z3AOuOthLF3fiK
 DZpEidceS8MAcbIRO9l8A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:R7fhh1BPNKs=:gtjNyxYX1lS7HX0Auo4ON2
 PMqXKc4miOpddUhUmHL6K6Dsxj4qk5QKPi/mrYrQf+7b94Vgs55TGTiLIKQ5lNsQqcmP5L1Zg
 7uGYcwUDR4xmkLpUU1e3h/cXDD66vzjL/L6vMNCnbeYmmWfQ7BBjUxh0KF8KAy7zu6ADJWrQv
 jzhYOJ0LrJ9NmK06+fxLNzjQzKDhYrNbcCt/ixpZ/oT0r3jGilT3nYH3gUrFlnBZwuX2XPbKg
 FUdQq34InIZZPD9J2LHL49Bw6Taq0b8yKqsqVLga7Cw+3cqMWU635pPf08bEXoresRHvzuX1g
 7Sw9zXTn0+RfI2e66f172Pz+coP3u4OK5LUJqAc6B5sw9C2RVnKWDoDHkKJFZpJEhFsVLtWsj
 gfdmGeyB4bZlH3Qi8rw+6uvPAq1sA17c0W3J5/o6bBu6JumUfAroGF0v8DZZEZaU/orzCyaft
 ubfna5xtjWZ0TZVHrlghmK0pniHTb1aRyV6u1xZqMcsjDyquka3HQjtHJvNifDEZAX8TgdbdB
 AP6PjjJ+OZa7Yj8R4B/Y5k2cBOS+9fN2cxP8Me2Z0RePOmV7G3ufH2V3bI7HsEidrHCl5sBJ7
 JF7P70rWPmsGusI2T0qM5+KDlXn6CE+pjNmcx8IW28OwIh8XN4VBJpbbLp3jsaWAx4aFtXiyI
 gDCDGfrXmx99ul0mDnJd8y4HFuZJ9g2keAGSwrGtd+BcGGQDIMbtpaSfx3xW7CsStiGm92/0F
 HfLDZ80/QRofG7x2K/ufn971IJDMoLZgAX8JjoSSjtgpHOAlBBmBL9gAa8KCZBn6921Edo885
 3bhXToXHVwET/uzxEdPcVGeqQtAm2r6IAC+Pu63j38Y0FFFl26zvQfi/iXVjbdXx5xgomM9po
 zBycpihMo0VcKPcaBiJ/o5uD/FtT7EcMbpPU/WmxNxc3rMMQCCURFtEka+vxqaECxYzj0DMaY
 3l2YnRwCiPdKDliVMIOyYVTTAG8deKqZm1lcwWzUex2gKKdp8xXsYljEi2xkh2PJ2o6dkt+Rs
 OryoecRwimNBrP3f1GTXiZnfPQMQAr5XELQ/ZI0e3qonMZUcvy6kjPGxFa39uQKMLVkN5sp7H
 motcmU36oSHOR6bPDcNcgvxjtCXPG8htautOLyHgNOVLncxN7YcxiaerZYa5ZOMBsY/U0NVYt
 6t3IwS/+SODYKOvcLi2ZtxQvArNXAQLWhBVUbO977jdX4j/1JbUt0lwtITK0b7k7eYTIt6Py6
 OdvN3Bu1UmzRaZBfV

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, there are the need to remove all
the function callback casts.

The first patch creates a macro called ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
to initialize the acpi_probe_entry struct using the probe_subtbl field
instead of the probe_table field to avoid function cast mismatches.

The second patch modifies the IRQCHIP_ACPI_DECLARE macro to use the new
defined macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY instead of the macro
ACPI_DECLARE_PROBE_ENTRY. Also, modifies the prototype of the functions
used by the invocation of the IRQCHIP_ACPI_DECLARE macro to match all the
parameters.

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

Oscar Carter (2):
  drivers/irqchip: Add new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
  drivers/irqchip: Use new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY

 drivers/irqchip/irq-gic-v3.c |  2 +-
 drivers/irqchip/irq-gic.c    |  2 +-
 include/linux/acpi.h         | 11 +++++++++++
 include/linux/irqchip.h      |  5 +++--
 4 files changed, 16 insertions(+), 4 deletions(-)

=2D-
2.20.1

