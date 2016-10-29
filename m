Reply-To: kernel-hardening@lists.openwall.com
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc> <20161029194224.GB3827@amd>
 <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc>
From: Daniel Gruss <daniel@gruss.cc>
Message-ID: <67ef8651-1d11-e54d-535e-0a24b1cbaf2b@gruss.cc>
Date: Sat, 29 Oct 2016 22:14:23 +0200
MIME-Version: 1.0
In-Reply-To: <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 29.10.2016 22:05, Daniel Gruss wrote:
> I'm very confident you're not successful the way you['re] starting ;)

Just to give a reason to that: on many systems you can have bitflips 
with far less than 1 or 2 million cache misses.
https://users.ece.cmu.edu/~yoonguk/papers/kim-isca14.pdf reports as 
little as 139K accesses (-> cache misses) to be sufficient on one of 
their systems and on one of my systems I can have a bit flip with as 
little as 78K cache misses (double sided hammering).
