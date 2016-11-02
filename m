Reply-To: kernel-hardening@lists.openwall.com
From: Adam Sampson <ats@offog.org>
References: <93057ac3-301d-ed5d-405d-93eb4e3deb30@yuhu.biz>
Date: Wed, 02 Nov 2016 16:10:30 +0000
In-Reply-To: <93057ac3-301d-ed5d-405d-93eb4e3deb30@yuhu.biz> (Marian Marinov's
	message of "Wed, 2 Nov 2016 05:42:41 +0200")
Message-ID: <y2apomdx3pl.fsf@offog.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: Adam Sampson <ats@offog.org>
Subject: Re: [kernel-hardening] Legitimate use of /proc/PID/mem,maps and smaps
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Marian Marinov <mm-l@yuhu.biz> writes:

> Are there any other legitimate users of these files, maybe X?

This is the kind of question that Debian Code Search is useful for
(although it's not exhaustive):
https://codesearch.debian.net/search?q=%2Fproc%2Fself%2Fmem&perpkg=1
https://codesearch.debian.net/search?q=%2Fproc%2Fself%2Fmaps&perpkg=1
https://codesearch.debian.net/search?q=%2Fproc%2Fself%2Fsmaps&perpkg=1

>From my bug-hunting experience, programs use /proc/self/maps for all
sorts of weird things -- e.g. working out the full path of the
executable, or what version of a shared library they've been linked
against, or guessing whether some random value is a valid pointer. Many
have embedded copies of code from gettext or BinReloc that uses it.

On the other hand, many of these don't actually need all the information
in /proc/self/maps, so you could get away with a simplified version that
only had valid filenames.

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>
