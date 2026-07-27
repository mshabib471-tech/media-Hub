import { NextResponse } from 'next/server';
export async function POST(request: Request){try{const body=await request.json(); if(!body.email && !body.phone) return NextResponse.json({error:'Contact info required'},{status:400}); return NextResponse.json({ok:true});}catch{return NextResponse.json({error:'Invalid contact payload'},{status:400})}}
