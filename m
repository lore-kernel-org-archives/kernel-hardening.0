Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 1F6A4606A31E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Nov 2026 13:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EgGt/NoM
Received: (qmail 20333 invoked by uid 550); 24 Nov 2026 13:29:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21694 invoked from network); 24 Nov 2026 12:49:57 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1795524587; cv=none;
        d=google.com; s=arc-20260327;
        b=VQZ1JUrHknzvzPbuQa+XhtjcEjAb02U/fG2y6/pDvHynpCUQI6iX16gSSo0uMHj2OK
         jELfiO55s7GaVebGBbyui9xoC+JA1JlUmJMzBxc1BX3wuzh4o8QuNGgfvjgqiAqR8A0i
         7whXdg1lBV+tumtls89cDyBtM81ZIKJTsQB1zyNE7w2etE0BNQNrddxFDBnExxSvYGGD
         hB/bb/ZOuZ8DESw9qp7+MELVP5BATbqpRt6RHC2zB9CFOuLyPxbmJCzIhWICVqk9ZXQ1
         uk/qAsyHd0uEJeddPHX9kS1HW22hx3WJPnWfv2FCR14yyB+l6lM87qOZ5wjdOrlFke0g
         DqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fJ7K3U8lgY7ENLAhw7JfkProGkSTxj/jcbYpZM4WWBM=;
        fh=ZyXpnt1Jmw5Y0aG5qDXnVuegzJ14vvB7M6YOt8pKetY=;
        b=bPfeGFpV5zweFEh3ek/D4P+BzVqFhFsmJp4kulDt4u4L/OYmwISO7+rTpP9p4tKzhD
         iqQCmHZHvPhpoucImbvgQov8BIV6ooKCU3g9DA1ZVmnMz/pBL/vzaBATTB8C0HAdeA5p
         +VbYjlEkVMK77P4H0tSqYQEvvRDoP0xDWXPcT4Gf+kbuSAwIPy0WJZOUnpJ8SdltDQDd
         ozmLn+KMxFSLTt8rIqcTfta5tY1YUpA76yy1yZJnCyZ8deT89/922nFFEp9HdSwK1Y5V
         ER3rigF91zpO8XB7ob7k5muhF9hLIizoMIBvEPWmlO3pUZS9kPzoTebt5SD7QjrPYdDl
         HCUA==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795524587; x=1796129387; darn=lists.openwall.com;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fJ7K3U8lgY7ENLAhw7JfkProGkSTxj/jcbYpZM4WWBM=;
        b=EgGt/NoMVTt4W+ebgOAFplO5xAplWUmz3v5Hf1WxK+3ULGBoJB8PnexM2Uxvj5uHhA
         2MEyvhA2AcJETzGNW3kCpL2NGPoGbjc84ksKRniZf3JX7c4KR6dBbt109j7ZUHfXwDWU
         AaH2jt63frAp+j9CYTqhmpk0vm3KfW2jF4i9PhaIOv6C+5Iy9d7nFuNTnq0pfDbz7dMn
         oECTUtgTvl5ygGjfQimKmiXWzmJwI8Ejj4CWLNTEjvuMdLS8tjeA75lrovL83szryZU2
         EiUfeBfrtHcQo0groWgW06Zdzbt0z3zfjl4joR8N4UIJLMOygPO36Jg8XMX2Bj7IjpkK
         lv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795524587; x=1796129387;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fJ7K3U8lgY7ENLAhw7JfkProGkSTxj/jcbYpZM4WWBM=;
        b=wfQiNQFaXXZ6VMKQ+eEK55wEi3UoMtypo2jmFjgRENBG5HDQHOqhU7cNNboMG3tuCO
         V2JojW85zJlvxFQhUhz0s4h/viitg/lhsEad0grkiMzPC1FE9ATlGxZt5CewITNSqKzT
         buCtuYOkaAeh9ANeaNGmPikNzTeWP4uMdzHOBWpEyVTYrPekMvKvs9ZQYVWySRVObgKM
         d+R3iGFYjuSZpwMgc2f3KYYez2dsjpRnMC38RLA88f/UdWyyqBUwukVkp+US67wSrwD1
         HKTpanzKRCj3chXPuShtTvHuVqmZ4lKrNdzX3Exr9FM9JzX/6rtWfcG48r1jMLkhcNFB
         0NnQ==
X-Gm-Message-State: APuU4Z+BIy1itPVMUvABRuR2z7Mw2aWFWE+sikVFOdbihJbPbkfsWAf0
	TdgeBxvEqHzm73ZCTrRTBQDK0P1CQGBzFhdAv3u3nXiDXqVPYNZ9vbMP2dq5i3FEucyDAsC1oJs
	T9xocqEf73C2g7Zey/8E1YpmfDwk26jdB36wCKKo=
X-Gm-Gg: AZFdTZdQWssXv/mi8H8dSqutmquJ4sfufoPrmiIQRWk7xThrtY9MatlnuuZ8VbkpJHF
	RKiYVxiqNTQ7bdVVMTfJ2kbnqQpoDwvQhHRuzTXsfGca1stQzYg0LdbqPEV4VWglodmE8vywYYI
	YyqevyIa/xnQAPIqouZhz0enxREkSSWP18zTfAnjG035NazfJjkPDOG8dDMBkd37fIeGYRFqEMA
	wDTkcb0YgkYgkoGO6k8ZPBE/XyGv3+QwB2jF0wSFX4BxVgoYRXi5QvMMeId0cYam8a2q4wp08Ng
	enNdBHLRAcGM7icubS2DZS7FwOgT8Di966Icwl6c4zmvg0bhYj0zEeD+UP5x6jouzLsmAWgYgnE
	UjlMSReuGI9/Ewrom99YZ0dKxuhKa0G0OOOv8/PCA20UA4d+5x01B1iAqc80ZMnEkr3jnr4NlrU
	N56Dmzuc5M
X-Received: by 2002:a67:e7cb:0:b0:7d0:6e40:f3e2 with SMTP id
 ada2fe7eead31-7d7396249a8mr7343986137.28.1795524587567; Tue, 24 Nov 2026
 04:49:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Suruur <suruurism@gmail.com>
Date: Tue, 24 Nov 2026 15:49:35 +0300
X-Gm-Features: Aa3M54rq_7TUUup2jtCuQ5CKhjKwBbU0LQAMdFRChIFu_ZS-qhxfcl8_MDjGJwM
Message-ID: <CAFkjbpC6MChCGjt2gJ-3RMNf1bWu09S27j0y=PudDiRFUif+YQ@mail.gmail.com>
Subject: Introduction: Linux Kernel Security Researcher Interested in KSPP Contributions
To: linux-hardening@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="0000000000003a407b06610525ae"
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--0000000000003a407b06610525ae
Content-Type: text/plain; charset="UTF-8"

Hi everyone,

My name is Abdifatah Suruur (suruurism), and I am an independent Linux
kernel security researcher.

Throughout 2026, I have contributed multiple security fixes upstream,
including:

- CVE-2026-80724 - ptp/vmclock: Missing VM_MAYWRITE clear on read-only
mappings.
- CVE-2026-80926 - ksmbd: Use-after-free in oplock break notification.
- CVE-2026-99272 through CVE-2026-99280 - A series of issues affecting
fs/smb/client and ksmbd.

I have published write-ups and selected PoCs here:
https://github.com/suruurism/cve-writeups-and-pocs

I am looking to expand my contributions beyond individual vulnerability
reports and focus on systemic Linux kernel hardening, addressing entire
classes of vulnerabilities rather than isolated bugs.

I am particularly interested in contributing to KSPP (Kernel
Self-Protection Project), starting with Coccinelle semantic patches and
small hardening series based on vulnerability patterns I have identified in
upstream code. Areas of interest include memory mapping flag handling,
concurrency issues in network filesystems, and capability and network
namespace checks.

I would welcome the opportunity to collaborate, learn from the community,
and contribute meaningful improvements to Linux kernel security.

Looking forward to contributing!

Best regards,
Abdifatah Suruur
Independent Linux Kernel Security Researcher
GitHub: https://github.com/suruurism
Email: suruurism@gmail.com

--0000000000003a407b06610525ae
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi everyone,<br><br>My name is Abdifatah Suruur (suruurism=
), and I am an independent Linux kernel security researcher.<br><br>Through=
out 2026, I have contributed multiple security fixes upstream, including:<b=
r><br>- CVE-2026-80724 - ptp/vmclock: Missing VM_MAYWRITE clear on read-onl=
y mappings.<br>- CVE-2026-80926 - ksmbd: Use-after-free in oplock break not=
ification.<br>- CVE-2026-99272 through CVE-2026-99280 - A series of issues =
affecting fs/smb/client and ksmbd.<br><br>I have published write-ups and se=
lected PoCs here:<br><a href=3D"https://github.com/suruurism/cve-writeups-a=
nd-pocs">https://github.com/suruurism/cve-writeups-and-pocs</a><br><br>I am=
 looking to expand my contributions beyond individual vulnerability reports=
 and focus on systemic Linux kernel hardening, addressing entire classes of=
 vulnerabilities rather than isolated bugs.<br><br>I am particularly intere=
sted in contributing to KSPP (Kernel Self-Protection Project), starting wit=
h Coccinelle semantic patches and small hardening series based on vulnerabi=
lity patterns I have identified in upstream code. Areas of interest include=
 memory mapping flag handling, concurrency issues in network filesystems, a=
nd capability and network namespace checks.<br><br>I would welcome the oppo=
rtunity to collaborate, learn from the community, and contribute meaningful=
 improvements to Linux kernel security.<br><br>Looking forward to contribut=
ing!<br><br>Best regards,<br>Abdifatah Suruur<br>Independent Linux Kernel S=
ecurity Researcher<br>GitHub: <a href=3D"https://github.com/suruurism">http=
s://github.com/suruurism</a><br>Email: <a href=3D"mailto:suruurism@gmail.co=
m">suruurism@gmail.com</a></div>

--0000000000003a407b06610525ae--
