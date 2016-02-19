Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56C79301.5040003@redhat.com>
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
	<CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
	<56C79301.5040003@redhat.com>
Date: Fri, 19 Feb 2016 14:19:18 -0800
Message-ID: <CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Laura Abbott <labbott@redhat.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 19, 2016 at 2:11 PM, Laura Abbott <labbott@redhat.com> wrote:
> On 02/19/2016 11:12 AM, Kees Cook wrote:
>>
>> On Thu, Feb 18, 2016 at 5:15 PM, Laura Abbott <labbott@fedoraproject.org>
>> wrote:
>>>
>>>
>>> In a similar manner to WRITE_AFTER_FREE, add a READ_AFTER_FREE
>>> test to test free poisoning features. Sample output when
>>> no sanitization is present:
>>>
>>> [   22.414170] lkdtm: Performing direct entry READ_AFTER_FREE
>>> [   22.415124] lkdtm: Value in memory before free: 12345678
>>> [   22.415900] lkdtm: Attempting to read from freed memory
>>> [   22.416394] lkdtm: Successfully read value: 12345678
>>>
>>> with sanitization:
>>>
>>> [   25.874585] lkdtm: Performing direct entry READ_AFTER_FREE
>>> [   25.875527] lkdtm: Value in memory before free: 12345678
>>> [   25.876382] lkdtm: Attempting to read from freed memory
>>> [   25.876900] general protection fault: 0000 [#1] SMP
>>>
>>> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
>>
>>
>> Excellent! Could you mention in the changelog which CONFIG (or runtime
>> values) will change the lkdtm test? (I thought there was a poisoning
>> style that would result in a zero-read instead of a GP?)
>>
>
> There was a zeroing patch in the first draft but given the direction
> things are going, I don't see it going in. I'll mention the debug
> options which will show this though.

Ah! Okay, I was having trouble following what was happening. What's
the current state of the use-after-free protections you've been
working on?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
