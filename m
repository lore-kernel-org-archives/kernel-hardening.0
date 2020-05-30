Return-Path: <SRS0=bkuF=7M=lists.openwall.com=kernel-hardening-return-18898-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95575C433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 12:46:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E40CE207BC
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 12:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="hbG6vPzq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E40CE207BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18898-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28471 invoked by uid 550); 30 May 2020 12:46:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28390 invoked from network); 30 May 2020 12:46:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590842779;
	bh=oPdJl+VzV24Bq81FHCLzq08lkWhQIV9dZZxlAWUssXs=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hbG6vPzqCe+1eIbbuo+qRekVBCJJxzFtV1K/Pea0QEX+8pTjkV2DJfqyAE7WAtLBL
	 dNyyqWaFYMcyoKontn+AEehlPXz0x/DSPpaIcLPVpO7oASA0qzvG/Q7pWTI5l/LLWp
	 Bv9z65TRmB4ZFJu3vh4MEPJJyqbwMo0Quj4EFciQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 30 May 2020 14:46:06 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
	Jason Cooper <jason@lakedaemon.net>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <lenb@kernel.org>, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/2] drivers/irqchip: Use new macro
 ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
Message-ID: <20200530124606.GA29479@ubuntu>
References: <20200529171847.10267-1-oscar.carter@gmx.com>
 <20200529171847.10267-3-oscar.carter@gmx.com>
 <590725ccfadc6e6c84c777f69ee02a62@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <590725ccfadc6e6c84c777f69ee02a62@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:O4ZjVuk7dgddTzBSN0ZnC8xOh36wLCSpKRpRgiCy4+M8PkuJQOx
 FL7bg3CFu89himtCZ3K/cz7GILT3EPOgIZG472jLjEporsYzf7YRexfMy/IM3wFcz1JOu3C
 vKkF+OSCarRdYg9BYFMXh0k+ICANDNtc9ERYEIu7Tih1tuTZK//m4LF0UzTnHaxKbq5mvOv
 bej7d+XHpEtOuwf19RCrw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vBAdlEhdIRY=:aJJnDT/sogHkcgRTgFdKrR
 YcpxMY/W0VlpJ7k5ZjibbcPJ2J9ikivEB5dJ8QKnIaWcDEV/QvOjKUup5QoEdWlC7L1E1aXmp
 PCrDeTeau/Yz7VbyRhKJXrEiH4Jz5YAaxFToIAUa7QoLyYITgZSvPIV4kDC3bwDxVapCf/vS7
 XnpY5bhApD2/dueGYp19W84CH96mLL0cmObUwVciMqG22Mrxdfu4+1TgJBmBgMc89WQIaAqG3
 P+IAVBBPqNDsMp4tSRaUiufJwfRAHEFeL9oFXBazjtsYTr9oL0FdnnSSQBA9/dSe2LXqUqK3P
 V+BDsgSeqPROGhUUdEoQXkYXERiNfA90rQhzFaSqbtaQ0Ps+W+Oo7f4t+fXfUWS/dPq2pe+wE
 maEH9cS6/7Y1aN0cnAepjhXTfkAn0/v5oTfO6mMz9WtpRwbMkwpA/uRoIBJiS72Zftn40HmGc
 ob9n3WmMXC4l9xglx+uhZjisOicT7bAZ9pobVwvNeoxjTYGOCfXt3SIEzDpPX+O0fEgqE6eif
 H/Yqk8pC4muXlPwELgsHOvpMbOays1nyi4ME5Ytppa9zmp8HrO4rEa2sFRuFUT30ysu36gh9U
 G2/gqZC+gpoMaUFJ1RbqoMvW4Y3rxTFcTCsdpgodz0QC5tN5b5csZQACIW2xKjbnAweAcF15d
 8MrIC/KlB/AvjWyJ+jWddNb8FNaQnk8X7REUXPI3DHikcjfHo1dCcsZjAcpAMbXrkAwJLsXz7
 iVCs2y1lKMv4Xp80STDLiLLU++9tP4wkOe3mtgL9ZxUn8L6f/JyWJMH6nb99oywi799956UYd
 Dtu+7A0d04igp2PaXgqVSQgc0r5iE5JzWyQ19I1RmQVi8NzsK4TI8JZt66L9T2+jVgwnrvij8
 F/+V31iB6/I7Om5f0v4scKbEE81EJThKNBEeX2nSFz7qvwWVvqSW8HTDCjrNzOhNiEQbbdfmZ
 gG3T2yR7ap26cvOdqYOrJQ0XUSdLady30fZsRsfMTMzp/ASTJHaBBuuUem5w1hqVEB+SOfIxv
 ukk7Zqh+gBAnjD3QCMf4oPqH0/XatxhSr39/N2Y6GbA7V1lRpnU5u0f3f5KDkKRpx5hB6MhgZ
 JzMQSP2Vi+3+xBp4OO1b1tPhzBD7lEDDmsNOV1WHQw7SX03x/cBd4KYCCR4vW4SnJkScknLhw
 FA8hrVX6cHINvmjtPSOWOIcmKgJqIyPyf2WdUqR4VFyTu6OvinRdvSIejHOlGdQh3c+uzS9Rb
 Yz6rPUSrE1/x4O9P1
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sat, May 30, 2020 at 10:34:51AM +0100, Marc Zyngier wrote:
>
> I can't help but notice that you have left the cast in
> ACPI_DECLARE_PROBE_ENTRY, which should definitely go. Probably worth a t=
hird
> patch.

Ok, I remove it and resend a new version.

> Thanks,
>
>         M.
>
> --
> Jazz is not dead. It just smells funny...

Thanks,
Oscar Carter
