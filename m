Return-Path: <kernel-hardening-return-22004-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B4573D1951B
	for <kernel-hardening@archiver.kernel.org>; Mon, 26 Jan 2026 20:58:38 +0000 (UTC)
Received: (qmail 11510 invoked by uid 550); 26 Jan 2026 20:58:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11414 invoked from network); 26 Jan 2026 20:58:27 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 320FA89D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
	t=1769461097; bh=KDsg4Xwcs1arQ7SUFIJ16Ldq0uYzZ8DDCOsGKuVRTNM=;
	h=Date:From:To:cc:Subject:From;
	b=tCrDj2khtFFDokf3bUTwaKjqCb2kNt+zpxKf9RfFgyR4eLzMcua75EyRJYpBZGh82
	 +mpEhAvtSrxBkHLwhe9wMDh11Q0EQTfqtDkidbRpsfdXtUxqp2QnsBJ2/dQwrlpux2
	 nLsjwj9AEG9pJ3IO6oUKXvW+TyZEMsHdTfQtTtGQ=
Date: Mon, 26 Jan 2026 12:58:17 -0800 (PST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>, 
    linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, 
    linux-integrity@vger.kernel.org, lwn@lwn.net, linux-crypto@vger.kernel.org, 
    keyrings@vger.kernel.org
Subject: [ANN] Linux Security Summit 2026 CfP
Message-ID: <4c3e8881-fc8d-a413-d3d1-be2a295de13@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

=============================================================================
                   ANNOUNCEMENT AND CALL FOR PARTICIPATION

                   LINUX SECURITY SUMMIT NORTH AMERICA 2026
                             
                                  May 21-22
                             Minneapolis, MN, USA
==============================================================================

DESCRIPTION
 
Linux Security Summit North America (LSS-NA) 2026 is a technical forum for
collaboration between Linux developers, researchers, and end-users.

Its primary aim is to foster community efforts in deeply analyzing and
solving Linux operating system security challenges, including those in the
Linux kernel.

Proposals should be submitted via:
    https://events.linuxfoundation.org/linux-security-summit-north-america/

SUGGESTED TOPICS

    * Access Control
    * Case Studies
    * Cryptography and Key Management
    * Emerging Technologies, Threats & Techniques
    * Hardware Security
    * IoT and Embedded Security
    * Integrity Policy and Enforcement
    * Open Source Supply Chain for the Linux OS
    * Security Tools
    * Security UX
    * Linux OS Hardening
    * Virtualization and Containers

DATES TO REMEMBER:

    * CFP Close: Sunday, March 15 at 11:59 PM CDT
    * CFP Notifications: Tuesday, March 31
    * Schedule Announced: Thursday, April 2
    * Event Date: Thursday, May 21 - Friday, May 22

WHO SHOULD ATTEND
 
We're seeking a diverse range of attendees and welcome participation by
people involved in Linux security development, operations, and research.
 
LSS is a unique global event that provides the opportunity to present and
discuss your work or research with key Linux security community members and
maintainers.  It's also useful for those who wish to keep up with the latest
in Linux security development and to provide input to the development
process.

MASTODON

  For event updates and announcements, follow:
    
    https://social.kernel.org/LinuxSecSummit
  
  #linuxsecuritysummit

PROGRAM COMMITTEE

  The program committee for LSS 2026 is:

    * James Morris, Microsoft
    * Serge Hallyn, Geico
    * Paul Moore, Microsoft
    * Stephen Smalley, NSA
    * Elena Reshetova, Intel
    * John Johansen, Canonical
    * Kees Cook, Google
    * Casey Schaufler
    * Mimi Zohar, IBM
    * David A. Wheeler, Linux Foundation

  The program committee may be contacted as a group via email:
    lss-pc () lists.linuxfoundation.org

