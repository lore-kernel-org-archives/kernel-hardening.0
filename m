MIME-Version: 1.0
In-Reply-To: <CAPDLWs8biiKptmmYj45mrc+KWrV93JNQP5eLHcgTGznMj_yBow@mail.gmail.com>
References: <1511850724-2381-1-git-send-email-me@tobin.cc> <CAJ1xhMXjSTV92DxRz269sB=fZLEXJimr7_8PX8viamm02+xN1w@mail.gmail.com>
 <20171128211003.GY17858@eros> <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
 <20171129101640.GC6217@eros> <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
 <20171129204812.GE6217@eros> <1512133747.17323.3.camel@gmail.com>
 <20171204001106.GB27780@eros> <1512362481.17323.9.camel@gmail.com>
 <20171204045522.GE27780@eros> <CAPDLWs8biiKptmmYj45mrc+KWrV93JNQP5eLHcgTGznMj_yBow@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Mon, 4 Dec 2017 10:51:53 +0530
Message-ID: <CAPDLWs-BFQ+NF15ntxFNS4MT2kVs+k9BUYreDZeYEP1sFLQJ+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> On Mon, Dec 4, 2017 at 10:25 AM, Tobin C. Harding <me@tobin.cc> wrote:
>>
>> > With the 'eval', no warning, it's fine.
>>
>> Why not use hex()?
>
>> >
>> >         foreach my $config_file (@config_files) {
>> > +               $config_file =~ s/\R*//g;
>>
>> Is there some reason you don't use chomp()?
>

Wrt your suggestions:

---
diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 9906dcf8b807..260b52e456f1 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -266,7 +266,7 @@ sub is_false_positive
 sub is_false_positive_ix86_32
 {
        my ($match) = @_;
-       state $page_offset = eval get_page_offset(); # only gets called once
+       state $page_offset = hex get_page_offset(); # only gets called once

        if ($match =~ '\b(0x)?(f|F){8}\b') {
                return 1;
@@ -313,7 +313,7 @@ sub get_page_offset
        }

        foreach my $config_file (@config_files) {
-               $config_file =~ s/\R*//g;
+               chomp $config_file;
                $page_offset = parse_kernel_config_file($config_file);
                if ($page_offset ne "") {
                        return $page_offset;


Thanks & Regards,
Kaiwan.
