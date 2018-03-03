MIME-Version: 1.0
In-Reply-To: <20180301210623.GA15198@eros>
References: <1519706711-18580-1-git-send-email-me@tobin.cc>
 <1519706711-18580-2-git-send-email-me@tobin.cc> <20180301210623.GA15198@eros>
From: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date: Sat, 3 Mar 2018 11:44:26 +0200
Message-ID: <CAJ1xhMWzxX=uuf4S6=augqSgSoh7ATUd=OMotgq3RgMHd13o_A@mail.gmail.com>
Subject: Re: [PATCH 1/3] leaking_addresses: skip all /proc/PID except /proc/1
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 1, 2018 at 11:06 PM, Tobin C. Harding <me@tobin.cc> wrote:
> On Tue, Feb 27, 2018 at 03:45:09PM +1100, Tobin C. Harding wrote:
>> When the system is idle it is likely that most files under /proc/PID
>> will be identical for various processes.  Scanning _all_ the PIDs under
>> /proc is unnecessary and implies that we are thoroughly scanning /proc.
>> This is _not_ the case because there may be ways userspace can trigger
>> creation of /proc files that leak addresses but were not present during
>> a scan.  For these two reasons we should exclude all PID directories
>> under /proc except '1/'
>>
>> Exclude all /proc/PID except /proc/1.
>>
>> Signed-off-by: Tobin C. Harding <me@tobin.cc>
>> ---
>>  scripts/leaking_addresses.pl | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
>> index 6e5bc57caeaa..fb40e2828f43 100755
>> --- a/scripts/leaking_addresses.pl
>> +++ b/scripts/leaking_addresses.pl
>> @@ -10,6 +10,14 @@
>>  # Use --debug to output path before parsing, this is useful to find files that
>>  # cause the script to choke.
>>
>> +#
>> +# When the system is idle it is likely that most files under /proc/PID will be
>> +# identical for various processes.  Scanning _all_ the PIDs under /proc is
>> +# unnecessary and implies that we are thoroughly scanning /proc.  This is _not_
>> +# the case because there may be ways userspace can trigger creation of /proc
>> +# files that leak addresses but were not present during a scan.  For these two
>> +# reasons we exclude all PID directories under /proc except '1/'
>> +
>>  use warnings;
>>  use strict;
>>  use POSIX;
>> @@ -472,6 +480,9 @@ sub walk
>>                       my $path = "$pwd/$file";
>>                       next if (-l $path);
>>
>> +                     # skip /proc/PID except /proc/1
>> +                     next if ($path =~ /\/proc\/(?:[2-9][0-9]*|1[0-9]+)/);
>
> Perhaps the intent of this is clearer?
>
>                         next if (($path =~ /^\/proc\/[0-9]+$/) &&
>                                  ($path !~ /^\/proc\/1$/));
>
>
> thanks,
> Tobin.

Hi Tobin,

The intent is crystal clear now. Thanks.

Here's something that generates the same output as the code above:
next if ($path !~ "^/proc/(1|[^0-9]+)\$");

I'm not insisting this be given any preference whatsoever.

Thanks.
