References: <20170603113007.GA1544@grsecurity.net>
From: Matt Brown <matt@nmatt.com>
Message-ID: <a0ecb79b-c65a-1e8f-83e5-275d9ac5ab6d@nmatt.com>
Date: Sat, 3 Jun 2017 11:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <20170603113007.GA1544@grsecurity.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 6/3/17 7:30 AM, Brad Spengler wrote:
> http://www.openwall.com/lists/kernel-hardening/2017/06/03/11
> 
> Guys, this is your *last warning*.  This stops *now* or I'm sending lawyers
> after you and the companies paying you to plagiarize our work and violate

I actually do not get paid to do this work. I was a happy user of your
patch while it was public. Now you took it away from the public and I'm
doing my small part to pick up the baton.

> our *registered* copyright (which for the record entitles us to punitive
> damages which now are very easily provable).  It's time to get serious
> about attribution -- what you are doing is completely unacceptable.  I'm
> already in contact with lawyers to prepare for the next time this happens.
> If any of this plagiarized and misattributed code actually made it into
> the Linux kernel, you'd all be in a world of pain.
> 
> Matt -- did you not see in the directory the Kconfig file was copy+pasted
> from the following:
> 
> # grsecurity - access control and security hardening for Linux
> # All code in this directory and various hooks located throughout the Linux kernel are
> # Copyright (C) 2001-2014 Bradley Spengler, Open Source Security, Inc.
> # http://www.grsecurity.net spender@grsecurity.net
> #
> # This program is free software; you can redistribute it and/or
> # modify it under the terms of the GNU General Public License version 2
> # as published by the Free Software Foundation.
> #
> # This program is distributed in the hope that it will be useful,
> # but WITHOUT ANY WARRANTY; without even the implied warranty of
> # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> # GNU General Public License for more details.
> #
> # You should have received a copy of the GNU General Public License
> # along with this program; if not, write to the Free Software
> # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> 

I am sincerely sorry about this. It will be corrected in v2. Would you
like this license included in the Kconfig and tpe_lsm.c or just one of
them? I didn't see a license at the top of grsecurity/grsec_tpe.c so I
didn't know what to include.

> Yet you are claiming copyright entirely over my work.  Your copy+pasted
> Kconfig entry didn't even adjust for your renaming of my sysctl variables.
> Search+replace of config and function names is not transformative, and
> I dare to think how much of your tpe_lsm.c is copy+pasted from cormander's
> LSM.
> 
> I know it must be hard for the KSPP, having no original ideas of its

I am not a part of KSPP nor do my patches/comments reflect on them.

> own, but this is not security or development.  It's mindless plagiarism
> and illegal.  Then to slap your own copyright over the whole copy+pasted
> thing is a total insult and demonstrates the complete lack of respect
> KSPP has for the work it can't accomplish anything without.  The KSPP
> and the companies funding it wouldn't be able to show a shred of perceived
> progress were it not for its ability to simply copy+paste portions of
> our work, because every time you modify something you introduce bugs and
> new vulnerabilities, demonstrating your cluelessness.
