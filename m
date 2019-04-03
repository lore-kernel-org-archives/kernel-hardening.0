Subject: Re: [PATCH v3 0/7] lib/string: Add strscpy_pad() function
References: <20190306214226.14598-1-tobin@kernel.org>
 <CAGXu5jJeFOBBiofjG6_rqbf+_0fbKC46pzyfoACWt+NBg-bXtg@mail.gmail.com>
 <20190403002527.GB29296@eros.localdomain>
From: shuah <shuah@kernel.org>
Message-ID: <5c780987-e8d4-a1cf-2ea6-a16087e4491d@kernel.org>
Date: Tue, 2 Apr 2019 18:29:39 -0600
MIME-Version: 1.0
In-Reply-To: <20190403002527.GB29296@eros.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, shuah <shuah@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 4/2/19 6:25 PM, Tobin C. Harding wrote:
> On Tue, Apr 02, 2019 at 02:37:57PM -0700, Kees Cook wrote:
>> On Wed, Mar 6, 2019 at 1:43 PM Tobin C. Harding <tobin@kernel.org> wrote:
>>> This set makes an attempt at adding a framework to kselftest for writing
>>> kernel test modules.  It also adds a script for use in creating script
>>> test runners for kselftest.  My macro-foo is not great, all criticism
>>> and suggestions very much appreciated.  The design is based on test
>>> modules lib/test_printf.c, lib/test_bitmap.c, lib/test_xarray.c.
>>
>> Hi Shuah,
>>
>> The bulk of this series is in the kselftests. Would you be willing to
>> carry this series?
>>
>> I think it might be able to use a v4 just to clean up the
>> script-finding logic, but I might be entirely missing something about
>> the best way to do it.
> 
> v4 to come once I grok the bash stuff you suggested in 'PATCH v3.1'.
> 

Yes I can take care of these. Will wait for v4

thanks,
-- Shuah
