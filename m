MIME-Version: 1.0
In-Reply-To: <eaac83ad-083d-f6b1-383f-e20e73ab7e1c@gmail.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <eaac83ad-083d-f6b1-383f-e20e73ab7e1c@gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Fri, 24 Nov 2017 09:28:03 +0100
Message-ID: <CAJHCu1+YMaGtwxHgAU7szqTXMs2b8o3bzVthfyaBN6Kp7co=gA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v3 2/2] Protected O_CREAT open in
 sticky directories
To: Pavel Vasilyev <dixlor@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-11-22 13:03 GMT+01:00 Pavel Vasilyev <dixlor@gmail.com>:
> ...
>> +
>> +When set to "2", notify about O_CREAT open missing the O_EXCL flag
>> +in world or group writable sticky directories.
>> +
>> +When set to "3", block O_CREAT open missing the O_EXCL flag
>> +in world writable sticky directories and notify (but don't block)
>> +in group writable sticky directories.
>> +
>> +When set to "4", block O_CREAT open missing the O_EXCL flag
>> +in world writable and group writable sticky directories.
>
> May be add:
>
> When set to "X", notify O_CREAT open missing the O_EXCL flag
> in world writable sticky directories and notify in group
> writable sticky directories.

Doesn't the "2" option already do this?
Did I misunderstood something?

Salvatore
