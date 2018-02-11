Subject: Re: [PATCH 2/6] genalloc: selftest
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-3-igor.stoppa@huawei.com>
 <CAOFm3uGNVu87qYzPufu+gGbTwuhp3cjfhKuNDkcmwn3+ysKTdg@mail.gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f95a064d-75e9-6ff3-2c11-4158a0ad1ca9@infradead.org>
Date: Sun, 11 Feb 2018 12:27:14 -0800
MIME-Version: 1.0
In-Reply-To: <CAOFm3uGNVu87qYzPufu+gGbTwuhp3cjfhKuNDkcmwn3+ysKTdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Philippe Ombredanne <pombredanne@nexb.com>, Igor Stoppa <igor.stoppa@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, Christoph Hellwig <hch@infradead.org>, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 02/11/18 12:22, Philippe Ombredanne wrote:
> On Sun, Feb 11, 2018 at 4:19 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
>> Introduce a set of macros for writing concise test cases for genalloc.
>>
>> The test cases are meant to provide regression testing, when working on
>> new functionality for genalloc.
>>
>> Primarily they are meant to confirm that the various allocation strategy
>> will continue to work as expected.
>>
>> The execution of the self testing is controlled through a Kconfig option.
>>
>> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> 
> <snip>
> 
>> --- /dev/null
>> +++ b/include/linux/genalloc-selftest.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0
> 
> nit... For a comment in .h this line should be instead its own comment
> as the first line:
>> +/* SPDX-License-Identifier: GPL-2.0 */

Why are we treating header files (.h) differently than .c files?
Either one can use the C++ "//" comment syntax.

> <snip>
> 
>> --- /dev/null
>> +++ b/lib/genalloc-selftest.c
>> @@ -0,0 +1,400 @@
>> +/* SPDX-License-Identifier: GPL-2.0
> 
> And for a comment in .c this line should use C++ style as the first line:
> 
>> +// SPDX-License-Identifier: GPL-2.0
> 
> Please check the docs for this (I know this can feel surprising but
> this has been debated at great length on list)
> 
> Thank you!
> 


-- 
~Randy
