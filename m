Return-Path: <kernel-hardening-return-21942-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 3C6B7C0219D
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2025 21:03:24 +0000 (UTC)
Received: (qmail 12286 invoked by uid 550); 10 Feb 2025 21:03:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12251 invoked from network); 10 Feb 2025 21:03:11 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 6B6F6C9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
	t=1739221382; bh=h3x3P3W8K+9OlCaN6BjlODAjJulvwo/lejT6q6M/Los=;
	h=Date:From:To:cc:Subject:From;
	b=ZyGYKtxXADc7f/1Rh/aC10cIngjwj16ltm/q3MfCt8DpEmDiqR+PtyGUWVSR0kvRz
	 WXzo9JxxhLYZGiDmsn7pRtZqTKtOIt2S8lftxNWQi+yDOhiUqDdhK6GX2dF3J+WjHA
	 woDtfm+66JQFoacJ2svGVd5rL0o5ADlT7Wh/OkFs=
Date: Mon, 10 Feb 2025 13:03:02 -0800 (PST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>, 
    linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, 
    linux-integrity@vger.kernel.org, lwn@lwn.net
Subject: [Announce] Linux Security Summit North America 2025 CfP
Message-ID: <35b17495-427f-549f-6e46-619c56545b34@namei.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-1759655948-1739221181=:1918214"
Content-ID: <1eebfa2-83a-d771-38e3-a986f4542214@namei.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1759655948-1739221181=:1918214
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <30fe1e86-d93-3681-6dff-9a32f4d6df6@namei.org>

The Call for Participation for the 2025 Linux Security Summit North 
America (LSS-NA) is now open.

LSS-NA 2025 is a technical forum for collaboration between Linux 
developers, researchers, and end-users. Its primary aim is to foster 
community efforts in deeply analyzing and solving Linux operating system 
security challenges, including those in the Linux kernel. Presentations 
are expected to focus deeply on new or improved technology and how it 
advances the state of practice for addressing these challenges.

Key dates:

    - CFP Closes:  Monday, March 10 at 11:59 PM MDT / 10:59 PM PDT
    - CFP Notifications: Monday, March 31
    - Schedule Announcement: Wednesday, April 2
    - Presentation Slide Due Date: Tuesday, June 24
    - Event Dates: Thursday, June 26 – Friday, June 27

Location: Denver, Colorado, USA (co-located with OSS).

Full details may be found here: 
https://events.linuxfoundation.org/linux-security-summit-north-america/

Follow LSS event updates here:
https://social.kernel.org/LinuxSecSummit



-- 
James Morris
<jmorris@namei.org>
--1665246916-1759655948-1739221181=:1918214--
