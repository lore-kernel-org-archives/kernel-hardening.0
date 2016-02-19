Reply-To: kernel-hardening@lists.openwall.com
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
 <CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56C79301.5040003@redhat.com>
Date: Fri, 19 Feb 2016 14:11:13 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@fedoraproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/19/2016 11:12 AM, Kees Cook wrote:
> On Thu, Feb 18, 2016 at 5:15 PM, Laura Abbott <labbott@fedoraproject.org> wrote:
>>
>> In a similar manner to WRITE_AFTER_FREE, add a READ_AFTER_FREE
>> test to test free poisoning features. Sample output when
>> no sanitization is present:
>>
>> [   22.414170] lkdtm: Performing direct entry READ_AFTER_FREE
>> [   22.415124] lkdtm: Value in memory before free: 12345678
>> [   22.415900] lkdtm: Attempting to read from freed memory
>> [   22.416394] lkdtm: Successfully read value: 12345678
>>
>> with sanitization:
>>
>> [   25.874585] lkdtm: Performing direct entry READ_AFTER_FREE
>> [   25.875527] lkdtm: Value in memory before free: 12345678
>> [   25.876382] lkdtm: Attempting to read from freed memory
>> [   25.876900] general protection fault: 0000 [#1] SMP
>>
>> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
>
> Excellent! Could you mention in the changelog which CONFIG (or runtime
> values) will change the lkdtm test? (I thought there was a poisoning
> style that would result in a zero-read instead of a GP?)
>

There was a zeroing patch in the first draft but given the direction
things are going, I don't see it going in. I'll mention the debug
options which will show this though.

> -Kees
>
>> ---
>> I split this out from the previous series
>> (http://article.gmane.org/gmane.linux.kernel.mm/143486) since
>> that series is going to be going in more incrementally.
>> Having the test in sooner than later will be helpful I think
>>
>> v2: Tweaked the output text to be clearer about what's going on.
>> Switched to using the middle of an allocated block instead of the beginning.
>> ---
>>   drivers/misc/lkdtm.c | 34 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 34 insertions(+)
>>
>> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
>> index 11fdadc..24d0ac7 100644
>> --- a/drivers/misc/lkdtm.c
>> +++ b/drivers/misc/lkdtm.c
>> @@ -92,6 +92,7 @@ enum ctype {
>>          CT_UNALIGNED_LOAD_STORE_WRITE,
>>          CT_OVERWRITE_ALLOCATION,
>>          CT_WRITE_AFTER_FREE,
>> +       CT_READ_AFTER_FREE,
>>          CT_SOFTLOCKUP,
>>          CT_HARDLOCKUP,
>>          CT_SPINLOCKUP,
>> @@ -129,6 +130,7 @@ static char* cp_type[] = {
>>          "UNALIGNED_LOAD_STORE_WRITE",
>>          "OVERWRITE_ALLOCATION",
>>          "WRITE_AFTER_FREE",
>> +       "READ_AFTER_FREE",
>>          "SOFTLOCKUP",
>>          "HARDLOCKUP",
>>          "SPINLOCKUP",
>> @@ -417,6 +419,38 @@ static void lkdtm_do_action(enum ctype which)
>>                  memset(data, 0x78, len);
>>                  break;
>>          }
>> +       case CT_READ_AFTER_FREE: {
>> +               int **base;
>> +               int *val, *tmp;
>> +               size_t len = 1024;
>> +               /*
>> +                * The slub allocator uses the first word to store the free
>> +                * pointer in some configurations. Use the middle of the
>> +                * allocation to avoid running into the freelist
>> +                */
>> +               size_t offset = (len/sizeof(int *))/2;
>> +
>> +               base = kmalloc(len, GFP_KERNEL);
>> +               if (!base)
>> +                       return;
>> +
>> +               val = kmalloc(len, GFP_KERNEL);
>> +               if (!val)
>> +                       return;
>> +
>> +               *val = 0x12345678;
>> +               pr_info("Value in memory before free: %x\n", *val);
>> +
>> +               base[offset] = val;
>> +               kfree(base);
>> +
>> +               tmp = base[offset];
>> +               pr_info("Attempting to read from freed memory");
>> +               pr_info("Successfully read value: %x\n", *tmp);
>> +
>> +               kfree(val);
>> +               break;
>> +       }
>>          case CT_SOFTLOCKUP:
>>                  preempt_disable();
>>                  for (;;)
>> --
>> 2.5.0
>>
>
>
>
