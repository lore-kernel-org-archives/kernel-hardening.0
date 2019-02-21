Subject: Re: [PATCH 3/6] lib/string: Use correct docstring format
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-4-tobin@kernel.org>
 <CAGXu5jJ++_VufY8t3WYsGW8VN-3yJEbVpOi_67RxHPicCC-K6A@mail.gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <45959376-49a1-467b-835e-f335fbd1c470@infradead.org>
Date: Wed, 20 Feb 2019 20:14:34 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJ++_VufY8t3WYsGW8VN-3yJEbVpOi_67RxHPicCC-K6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <tobin@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2/20/19 4:07 PM, Kees Cook wrote:
> On Mon, Feb 18, 2019 at 3:24 PM Tobin C. Harding <tobin@kernel.org> wrote:
>>
>> Currently the docstring comments for strscpy() are not in the correct
>> format.  Prior to working on this file fix up the docstring.
>>
>> Use correct docstring format for strscpy().
> 
> Is this attached to "make htmldocs" anywhere? Maybe in the device
> driver api doc? That's where I put refcount_t. See
> driver-api/basics.rst and put something like:
> 
> String Handling
> --------------------
> 
> .. kernel-doc:: lib/string.c
>    :internal:
> 
> and add that chunk to this patch.

It's already in Documentation/core-api/kernel-api.rst, under
"String Manipulation."

> Acked-by: Kees Cook <keescook@chromium.org>
> 
> -Kees
> 
>>
>> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
>> ---
>>  lib/string.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/string.c b/lib/string.c
>> index 7f1d72db53c5..65969cf32f5d 100644
>> --- a/lib/string.c
>> +++ b/lib/string.c
>> @@ -159,11 +159,9 @@ EXPORT_SYMBOL(strlcpy);
>>   * @src: Where to copy the string from
>>   * @count: Size of destination buffer
>>   *
>> - * Copy the string, or as much of it as fits, into the dest buffer.
>> - * The routine returns the number of characters copied (not including
>> - * the trailing NUL) or -E2BIG if the destination buffer wasn't big enough.
>> - * The behavior is undefined if the string buffers overlap.
>> - * The destination buffer is always NUL terminated, unless it's zero-sized.
>> + * Copy the string, or as much of it as fits, into the dest buffer.  The
>> + * behavior is undefined if the string buffers overlap.  The destination
>> + * buffer is always NUL terminated, unless it's zero-sized.
>>   *
>>   * Preferred to strlcpy() since the API doesn't require reading memory
>>   * from the src string beyond the specified "count" bytes, and since
>> @@ -175,6 +173,9 @@ EXPORT_SYMBOL(strlcpy);
>>   * doesn't unnecessarily force the tail of the destination buffer to be
>>   * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy(),
>>   * check the return size, then just memset() the tail of the dest buffer.
>> + *
>> + * Return: The number of characters copied (not including the trailing
>> + *         NUL) or -E2BIG if the destination buffer wasn't big enough.
>>   */
>>  ssize_t strscpy(char *dest, const char *src, size_t count)
>>  {
>> --
>> 2.20.1
>>
> 
> 


-- 
~Randy
