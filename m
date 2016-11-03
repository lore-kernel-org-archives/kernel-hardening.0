Reply-To: kernel-hardening@lists.openwall.com
References: <93057ac3-301d-ed5d-405d-93eb4e3deb30@yuhu.biz>
 <y2apomdx3pl.fsf@offog.org>
From: Marian Marinov <mm-l@yuhu.biz>
Message-ID: <7e3957d4-9729-63cc-dea7-c27e842a6e87@yuhu.biz>
Date: Thu, 3 Nov 2016 02:54:13 +0200
MIME-Version: 1.0
In-Reply-To: <y2apomdx3pl.fsf@offog.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Legitimate use of /proc/PID/mem,maps and smaps
To: Adam Sampson <ats@offog.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/02/2016 06:10 PM, Adam Sampson wrote:
> Marian Marinov <mm-l@yuhu.biz> writes:
>
>> Are there any other legitimate users of these files, maybe X?
> This is the kind of question that Debian Code Search is useful for
> (although it's not exhaustive):
> https://codesearch.debian.net/search?q=%2Fproc%2Fself%2Fmem&perpkg=1
> https://codesearch.debian.net/search?q=%2Fproc%2Fself%2Fmaps&perpkg=1
> https://codesearch.debian.net/search?q=%2Fproc%2Fself%2Fsmaps&perpkg=1
>
> >From my bug-hunting experience, programs use /proc/self/maps for all
> sorts of weird things -- e.g. working out the full path of the
> executable, or what version of a shared library they've been linked
> against, or guessing whether some random value is a valid pointer. Many
> have embedded copies of code from gettext or BinReloc that uses it.
>
> On the other hand, many of these don't actually need all the information
> in /proc/self/maps, so you could get away with a simplified version that
> only had valid filenames.
>
Hmm I probably did not explained what I want. I know I can not (easily)limit a program to access its own memory(that would be stupid).

Pretend that user joe is running top and his top has pid of 1154. Now joe runs a php script and that script wants to open /proc/1154/maps and so on.

I believe that the kernel should not allow the php process(even thou it is from the same user to read those files, that are private to the top application). Actually I would like to make them invisible for all processes and users except the program 
that is the actual owner of the files and privileges users.

Does that seam logical to you guys?


Marian
