MIME-Version: 1.0
In-Reply-To: <20171129101640.GC6217@eros>
References: <1511850724-2381-1-git-send-email-me@tobin.cc> <CAJ1xhMXjSTV92DxRz269sB=fZLEXJimr7_8PX8viamm02+xN1w@mail.gmail.com>
 <20171128211003.GY17858@eros> <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
 <20171129101640.GC6217@eros>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Wed, 29 Nov 2017 16:32:54 +0530
Message-ID: <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, Nov 29, 2017 at 3:46 PM, Tobin C. Harding <me@tobin.cc> wrote:
> On Wed, Nov 29, 2017 at 09:59:59AM +0200, Alexander Kapshuk wrote:
>> On Tue, Nov 28, 2017 at 11:10 PM, Tobin C. Harding <me@tobin.cc> wrote:
>> > On Tue, Nov 28, 2017 at 03:16:24PM +0200, Alexander Kapshuk wrote:
>> >> On Tue, Nov 28, 2017 at 8:32 AM, Tobin C. Harding <me@tobin.cc> wrote:
>> >> >  Options:
>> >> >
>> >> > -       -o, --output-raw=<file>  Save results for future processing.
>> >> > -       -i, --input-raw=<file>   Read results from file instead of scanning.
>> >> > -           --raw                Show raw results (default).
>> >> > -           --suppress-dmesg     Do not show dmesg results.
>> >> > -           --squash-by-path     Show one result per unique path.
>> >> > -           --squash-by-filename Show one result per unique filename.
>> >> > -       -d, --debug              Display debugging output.
>> >> > -       -h, --help, --version    Display this help and exit.
>> >> > +       -o, --output-raw=<file>         Save results for future processing.
>> >> > +       -i, --input-raw=<file>          Read results from file instead of scanning.
>> >> > +             --raw                       Show raw results (default).
>> >> > +             --suppress-dmesg            Do not show dmesg results.
>> >> > +             --squash-by-path            Show one result per unique path.
>> >> > +             --squash-by-filename        Show one result per unique filename.
>> >> > +           --page-offset-32bit=<hex>   PAGE_OFFSET value (for 32-bit kernels).
>> >> > +           --kernel-config-file=<file> Kernel configuration file (e.g /boot/config)
>> >> > +       -d, --debug                     Display debugging output.
>> >> > +       -h, --help, --version           Display this help and exit.
>> >> >
Thanks for the whitespace fixes..

>> >>
>> >> Get_page_offset attempts to build a list of config files, which are
>> >> then passed into the parsing function for further processing.
>> >> This splits up the code to do with the config files between
>> >> get_page_offset() and parse_kernel_config_file().
>> >> May I suggest putting the kernel config file processing code into the
>> >> parse_kernel_config_file() instead, and let the parsing function
>> >> handle the config files and either return the page_offset or an empty
>> >> string.
>> >>
>> >> See below for the proposed implementation.

Thanks Alexander..

>> >
>> > Nice, this is much better! Thanks.
>> >
>> >> Apologies for the absence of indentation.
>> >
>> > Re-posting with indentation, comments in line.
>> >
>> >> Disclaimer: I did not test-run the code being proposed.
>> >
>> > I also did not test my comments ;)
>> >
>> >> sub get_page_offset
>> >> {
>> >>       my $default_offset = "0xc0000000";
>> >>       my $page_offset;
>> >>
>> >>       # Allow --page-offset-32bit to over ride.
>> >>       if ($page_offset_32bit != 0) {
>> >>               return $page_offset_32bit;
>> >>       }
>> >>
>> >>       $page_offset = parse_kernel_config_file();
>> >>       if ($page_offset ne "") {
>> >>               return $page_offset
>> >>       }
>> >>
>> >>       printf STDERR "Failed to parse kernel config files\n";
>> >>       printf STDERR "Falling back to %s\n", $default_offset;
>> >>
>> >>       return $default_offset;

This "fallback to 0xc0000000" I don't really agree with.
Obviously, there are platforms out there that do not use a PAGE_OFFSET value of
0xc0000000. So I think that defaulting to this is kinda presumptive;
much better, IMHO,
if we just fail and ask the user to pass the "correct" PAGE_OFFSET value via
the '--page-offset-32bit=' option switch.
What do you say?

>> >> }
>> >>

>> > perhaps
>> >                 my $tmpkconf = '/tmp/tmpkconf';
>>
>> my $tmpkconf is almost as long as /tmp/tmpkconf. The name of the tmp
>> file is self explanatory.
>> Using a variable instead of the filename in this particular context is
>> a matter of personal preference. If you prefer to use the variable
>> here, it's your call.
>
> I'm a stickler for no const strings or magic numbers but it's Kaiwan's
> patch, if he puts it in with const strings I'll apply it as is :)

I'd say in this case it's self-evident; IMO, we could leave it as a
const string..

>> >
>> >>               if (system("gunzip < /proc/config.gz > /tmp/tmpkconf") == 0) {
>> >>                       push @config_files, "/tmp/tmpkconf";
>> >>               }
>> >>       }
>> >
>> > Won't there only ever be a single config file? So if /proc/config.gz is
>> > readable we could do
>>
>> The code above builds a list of config files.
>> Assigning to @config_files as shown below would wipe out the config
>> files appended to the list so far, would it not?
>> So $tmpkconf needs appending to the list.
>
> You are correct, since the beginning of this function that has been the
> algorithm. My observation is that if /proc/config.gz is present then we
> don't need to parse the other files so it is better to blow them away.
>
> I don't know enough about the whole Linux-sphere to know if this is
> correct. But it seems reasonable that even if there is more than one way
> to look at the running kernels config file they will all be the same,
> the system would be pretty broken if they were different.
>
> So once we have found a readable config file just parse it and be done
> with it, no need to loop over any others.

Agreed.

> thanks,
> Tobin.

Tobin, am unsure why but I can't seem to apply your patch (on the
commit you specified: 4.15-rc1).
So have been unable to test so far.. Am copying the patch off the
email, saving and trying:

linux $ git apply --check ../tobin_patch_28nov17.patch
error: patch failed: scripts/leaking_addresses.pl:35
error: scripts/leaking_addresses.pl: patch does not apply
linux $

??

Thanks,
Kaiwan.
